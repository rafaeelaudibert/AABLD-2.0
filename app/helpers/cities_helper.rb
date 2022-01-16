# frozen_string_literal: true

module CitiesHelper
  def city_monthly_travel_chart_for(city)
    source_data = city.user_tickets_as_source.group_by_month(:created_at, last: 12).count
    destination_data = city.user_tickets_as_destination
                           .group_by_month(:created_at,
                                           last: 12)
                           .count

    options = create_chart_options(
      title: 'Viagens',
      subtitle: 'Agrupado por Mês',
      xtitle: 'Mês',
      ytitle: 'Viagens',
      palette: 'palette7',
      stacked: true
    )

    column_chart(
      [
        { name: 'Viagens de origem', data: source_data },
        { name: 'Viagens de destino', data: destination_data }
      ],
      options
    )
  end

  def city_monthly_value_chart_for(city)
    pre_data_s = city.user_tickets_as_source
                     .group_by { |ut| date_hash_string ut.created_at }
                     .transform_values { |val| val.sum(&:transfered_total) }

    source_data = UserTicket.group_by_month(:created_at, last: 12)
                            .count
                            .map { |ut| [ut[0], pre_data_s.fetch(date_hash_string(ut[0]), 0)] }

    pre_data_d = city.user_tickets_as_destination
                     .group_by { |ut| date_hash_string ut.created_at }
                     .transform_values { |val| val.sum(&:transfered_total) }

    destination_data = UserTicket.group_by_month(:created_at, last: 12)
                                 .count
                                 .map do |ut|
                                   [ut[0],
                                    pre_data_d.fetch(date_hash_string(ut[0]), 0)]
                                 end

    options = create_chart_options(
      title: 'Valor repassado',
      subtitle: 'Agrupado por Mês',
      xtitle: 'Mês',
      ytitle: 'Valor',
      palette: 'palette6',
      stacked: true
    )

    column_chart(
      [
        { name: 'Viagens de origem', data: source_data },
        { name: 'Viagens de destino', data: destination_data }
      ],
      options
    )
  end
end
