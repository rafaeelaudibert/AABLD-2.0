# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'associacaoAABLD@gmail.com'
  layout 'mailer'
end
