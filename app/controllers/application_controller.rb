class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :check_authentication, unless: :bypass_authentication_check?
  helper_method :current_user, :logged_in?


  private

  def check_authentication
    redirect_to login_url, notice: "Access denied, please log in" unless logged_in?
  end

  def bypass_authentication_check?
    false
  end

  def current_user
    return @current_user if defined? @current_user
    @current_user = begin
      id = TWG4::Auth.new(cookies).current_user_id
      User.find_by(id: id) if id
    end
  end

  def logged_in?
    not current_user.nil?
  end

end
