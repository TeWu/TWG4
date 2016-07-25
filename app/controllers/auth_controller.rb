class AuthController < ApplicationController
  layout 'login_page'
  skip_authorization_check


  def root
    redirect_to (logged_in? ? albums_path : login_path)
  end

  def login
    credentials = params.require(:credentials)
    user = User.authenticate(credentials[:username], credentials[:password])
    if user
      self.current_user = user
      redirect_to albums_path
    else
      logout_current_user
      redirect_to login_path, flash: {username: credentials[:username], alert: "Incorrect username or password"}
    end
  end

  def logout
    logout_current_user
    redirect_to login_path, notice: "Logged out"
  end

end
