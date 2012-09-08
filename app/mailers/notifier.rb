class Notifier < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.reset_password.subject
  #
  def reset_password
    # TODO: Implement actual functionality  --  Wed Jun 13 15:26:53 2012
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.activation_needed_email.subject
  #
  def activation_needed_email(user)
    # TODO: Implement actual functionality  --  Wed Jun 13 15:26:53 2012
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.activation_success_email.subject
  #
  def activation_success_email(user)
    # TODO: Implement actual functionality  --  Wed Jun 13 15:26:53 2012
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
