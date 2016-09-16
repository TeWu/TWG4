class ApplicationController < ActionController::Base
  include TWG4::Authentication::ControllerExtensions
  include NestedAuthorizationCheckers
  include ViewPreparation
  protect_from_forgery with: :exception
  check_authorization


  protected

  def current_ability
    current_user.try(:ability) || User.guest_ability
  end


  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to login_url, alert: exception.message }
      format.json { head :forbidden }
    end
  end

end
