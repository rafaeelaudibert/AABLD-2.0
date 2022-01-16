# frozen_string_literal: true

ActionView::Base.field_error_proc = proc do |html_tag, instance|
  form_fields = %w[textarea input select]

  Nokogiri::HTML::DocumentFragment.parse(html_tag).css(form_fields.join(', ')).each do |element|
    next unless form_fields.include? element.node_name

    error_message = if instance.error_message.is_a?(Array)
                      instance.error_message.uniq.join('<br/>')
                    else
                      instance.error_message
                    end

    html_tag = Nokogiri::HTML::DocumentFragment.parse(html_tag)
    html_tag.children.add_class 'is-invalid'
    html_tag = "#{html_tag}<div class='invalid-feedback'>#{error_message}</div>".html_safe # rubocop:disable Rails/OutputSafety
  end

  html_tag
end
