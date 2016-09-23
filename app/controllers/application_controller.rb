class ApplicationController < ActionController::Base
  include TWG4::Authentication::ControllerExtensions
  include NestedAuthorizationCheckers
  include ViewPreparation
  protect_from_forgery with: :exception
  check_authorization


  protected

  def is_permitted_in_demo?(user)
    user.nil? or user.id != TWG4::CONFIG[:demo][:real_admin_user_id] or current_user.try(:id) == TWG4::CONFIG[:demo][:real_admin_user_id]
  end

  def respond_with_not_permitted_in_demo_msg(redirection_target = nil)
    if redirection_target.nil?
      render json: {alert: not_permitted_in_demo_msg}, status: :unprocessable_entity
    else
      respond_to do |format|
        format.html { redirect_to redirection_target, alert: not_permitted_in_demo_msg }
        format.json { render json: {alert: not_permitted_in_demo_msg}, status: :unprocessable_entity }
      end
    end
  end

  def not_permitted_in_demo_msg
    "This operation is not permitted in demo version"
  end


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
