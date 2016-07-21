class AuthController < ApplicationController
  layout 'login_page'
  before_action :set_auth, except: :root


  def root
    redirect_to (logged_in? ? albums_path : login_path)
  end

  def login
    credentials = params.require(:credentials)
    user = User.authenticate(credentials[:username], credentials[:password])
    if user
      @auth.login_user(user)
      redirect_to albums_path
    else
      @auth.logout_current_user
      redirect_to login_path, flash: {username: credentials[:username], alert: "Incorrect username or password"}
    end
  end

  def logout
    @auth.logout_current_user
    redirect_to login_path, notice: "Logged out"
  end


  private

  def set_auth
    @auth = TWG4::Auth.new(cookies)
  end

  def bypass_authentication_check?
    true
  end

end
