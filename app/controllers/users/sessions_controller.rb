class Users::SessionsController < Devise::SessionsController
  def create
    email = params.dig(:user, :email)
    password = params.dig(:user, :password)

    if email.blank? || password.blank?
      redirect_to new_user_session_path, alert: email.blank? ? I18n.t("devise.failure.not_found_in_database") : I18n.t("devise.failure.invalid")
    else
      super
    end
  end
end
