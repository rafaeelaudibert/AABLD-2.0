# frozen_string_literal: true

module DashboardHelper
  def dashboard_monthly_user_chart
    data = Transaction.joins(:user_tickets).distinct.group_by_month(:created_at, last: 12).count

    options = create_chart_options(
      title: 'Usuários',
      subtitle: 'Agrupado por Mês',
      xtitle: 'Mês',
      ytitle: 'Usuários',
      palette: 'palette7',
      stacked: true
    )

    area_chart({ name: 'Usuários', data: data }, options)
  end

  def dashboard_monthly_travel_chart
    pre_data = UserTicket.all
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
      palette: 'palette3',
      stacked: true
    )

    area_chart({ name: 'Viagens', data: data }, options)
  end

  def dashboard_monthly_value_chart
    pre_data = UserTicket.all
                         .group_by { |ut| date_hash_string ut.created_at }
                         .transform_values { |val| val.sum(&:transfered_total) }

    data = UserTicket.group_by_month(:created_at)
                     .count
                     .map { |ut| [ut[0], pre_data.fetch(date_hash_string(ut[0]), 0)] }

    # If there is no data, return earlier
    return render(partial: 'empty_chart', locals: { chart_title: 'Valor' }) if data.length.zero?

    options = create_chart_options(
      title: 'Valor Repassado',
      subtitle: 'Agrupado por Mês',
      xtitle: 'Mês',
      ytitle: 'Valor',
      palette: 'palette9',
      stacked: true
    )

    area_chart({ name: 'Valor', data: data }, options)
  end
end
