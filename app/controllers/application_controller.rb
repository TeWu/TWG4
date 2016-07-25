class ApplicationController < ActionController::Base
  include NestedAuthorizationCheckers
  protect_from_forgery with: :exception
  check_authorization
  helper_method :current_user, :logged_in?


  protected

  def current_user
    return @current_user if defined? @current_user
    @current_user = begin
      id = TWG4::Auth.new(cookies).current_user_id
      User.find_by(id: id) if id
    end
  end

  def current_ability
    current_user.try(:ability) || User.guest_ability
  end

  def logged_in?
    not current_user.nil?
  end


  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to login_url, alert: exception.message }
    end
  end

end
