# frozen_string_literal: true

module TicketsHelper
  def format_currency(value)
    number_to_currency value, unit: 'R$', separator: ',', delimiter: '.', format: '%u %n'
  end

  def ticket_monthly_user_chart_for(ticket)
    pre_data = ticket.user_tickets
                     .group_by { |ut| date_hash_string ut.created_at }
                     .transform_values { |val| val.map(&:user_id).uniq.count }

    data = UserTicket.group_by_month(:created_at, last: 12)
                     .count
                     .map { |ut| [ut[0], pre_data.fetch(date_hash_string(ut[0]), 0)] }

    options = create_chart_options(
      title: 'Usuários',
      subtitle: 'Agrupado por Mês',
      xtitle: 'Mês',
      ytitle: 'Usuários',
      palette: 'palette7'
    )

    area_chart({ name: 'Usuários', data: data }, options)
  end

  def ticket_monthly_value_chart_for(ticket)
    pre_data = ticket.user_tickets
                     .group_by { |ut| date_hash_string ut.created_at }
                     .transform_values { |val| val.sum(&:original_value) / val.count }

    data = UserTicket.group_by_month(:created_at, last: 12)
                     .count
                     .map { |ut| [ut[0], pre_data.fetch(date_hash_string(ut[0]), 0)] }

    options = create_chart_options(
      title: 'Valor médio',
      subtitle: 'Agrupado por Mês',
      xtitle: 'Mês',
      ytitle: 'Valor'
    )

    area_chart({ name: 'Valor', data: data }, options)
  end
end
