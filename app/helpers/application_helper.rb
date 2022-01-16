# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend
  include EnumI18nHelper

  def paginate(pagy)
    "<div class='float-right'>#{pagy_bootstrap_nav(pagy)}</div>"
  end

  def date_hash_string(date)
    "#{date.month}/#{date.year}"
  end

  def create_chart_options(**kwargs)
    {
      title: kwargs.fetch(:title, 'Title'),
      subtitle: kwargs.fetch(:subtitle, 'Subtitle'),
      xtitle: kwargs.fetch(:xtitle, 'xTitle'),
      ytitle: kwargs.fetch(:ytitle, 'yTitle'),
      theme: kwargs.fetch(:palette, 'palette4'),
      stacked: kwargs.fetch(:stacked, true),
      xaxis: { labels: { format: 'MMM' } }
    }
  end
end
