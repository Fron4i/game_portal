class ApplicationController < ActionController::Base
  include Pundit::Authorization

  allow_browser versions: :modern

  stale_when_importmap_changes

  before_action :configure_permitted_parameters, if: :devise_controller?

  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def skip_pundit?
    devise_controller? || is_a?(Rails::HealthController)
  end

  def user_not_authorized
    flash[:alert] = t("pundit.not_authorized")
    redirect_to(user_signed_in? ? "/" : new_user_session_path)
  end
end
