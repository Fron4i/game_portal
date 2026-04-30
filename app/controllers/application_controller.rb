class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend

  allow_browser versions: :modern

  stale_when_importmap_changes

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  after_action :verify_authorized, unless: -> { action_name == "index" || skip_pundit? }

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def set_locale
    requested = params[:locale]&.to_sym
    chosen    = if I18n.available_locales.include?(requested)
                  requested
                elsif I18n.available_locales.include?(session[:locale]&.to_sym)
                  session[:locale].to_sym
                else
                  I18n.default_locale
                end
    I18n.locale = chosen
    session[:locale] = chosen.to_s
  end

  def skip_pundit?
    devise_controller? || is_a?(Rails::HealthController)
  end

  def user_not_authorized
    flash[:alert] = t("pundit.not_authorized")
    redirect_to(user_signed_in? ? "/" : new_user_session_path)
  end

  def record_not_found
    render plain: "Not found", status: :not_found
  end
end
