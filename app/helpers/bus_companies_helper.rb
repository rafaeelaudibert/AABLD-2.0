# frozen_string_literal: true

module BusCompaniesHelper
  def bus_company_monthly_travel_chart_for(bus_company)
    pre_data = bus_company.user_tickets
                          .group_by { |ut| date_hash_string ut.created_at }
                          .transform_values { |val| val.sum(&:quantity) }

    data = UserTicket.group_by_month(:created_at, last: 12)
                     .count
                     .map { |ut| [ut[0], pre_data.fetch(date_hash_string(ut[0]), 0)] }

    options = create_chart_options(
      title: 'Viagens',
      subtitle: 'Agrupado por Mês',
      xtitle: 'Mês',
      ytitle: 'Viagens',
      palette: 'palette7'
    )

    area_chart({ name: 'Viagens', data: data }, options)
  end

  def bus_company_monthly_value_chart_for(bus_company)
    pre_data = bus_company.user_tickets
                          .group_by { |ut| date_hash_string ut.created_at }
                          .transform_values { |val| val.sum(&:total) }

    data = UserTicket.group_by_month(:created_at, last: 12)
                     .count
                     .map { |ut| [ut[0], pre_data.fetch(date_hash_string(ut[0]), 0)] }

    transfered_data = data.map { |ut| [ut[0], ut[1] * Ticket::TRANSFER_RATE] }

    options = create_chart_options(
      title: 'Valor',
      subtitle: 'Agrupado por Mês',
      xtitle: 'Mês',
      ytitle: 'Valor',
      stacked: false
    )

    area_chart(
      [
        { name: 'Valor total', data: data },
        { name: 'Valor ressarcido', data: transfered_data }
      ],
      options
    )
  end
end
