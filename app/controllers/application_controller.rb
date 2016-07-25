class ApplicationController < ActionController::Base
  include NestedAuthorizationCheckers
  protect_from_forgery with: :exception
  check_authorization


  protected

  def current_ability
    current_user.try(:ability) || User.guest_ability
  end


  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to login_url, alert: exception.message }
    end
  end

end
