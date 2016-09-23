class UsersController < ApplicationController
  load_and_authorize_resource except: :index, find_by: :param


  def index
    prepare_and_render_view :index
  end

  view_preparation :index do
    authorize! :index, User
    @users = User.accessible_by(current_ability)
    @new_user = @user || User.new(current_ability.attributes_for(:new, User))
  end

  def create
    @user.roles = authorized_roles_param
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User created successfully" }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { prepare_and_render_view :index }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @user.id <= TWG4::CONFIG[:demo][:protected_users_max_id] and current_user.try(:id) != TWG4::CONFIG[:demo][:real_admin_user_id]
      respond_with_not_permitted_in_demo_msg @user and return
    end

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User updated successfully" }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html do
          @user_to_update = @user
          @user = User.find(params[:id])
          render :show
        end
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @user.id <= TWG4::CONFIG[:demo][:protected_users_max_id] and current_user.try(:id) != TWG4::CONFIG[:demo][:real_admin_user_id]
      respond_with_not_permitted_in_demo_msg @user and return
    end

    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User deleted successfully" }
      format.json { head :no_content }
    end
  end


  private

  def user_params
    params.require(:user).permit(:display_name, :username, :password, :password_confirmation).merge(roles: authorized_roles_param)
  end

  def authorized_roles_param
    old_roles = (@user.present? && @user.persisted?) ? @user.roles : TWG4::CONFIG[:new_user_roles_default]
    new_roles = params.require(:user)[:roles]
    raise(Exception, "Illegal roles param value") unless new_roles.nil? || new_roles.class == Array
    if new_roles.nil? || new_roles == old_roles
      old_roles
    elsif can?(:assign_all_roles, @user || User)
      new_roles
    elsif can?(:assign_nongranting_roles, @user || User)
      new_nongranting_roles = new_roles.select { |r| r.in? TWG4::CONFIG[:nongranting_roles] }
      old_granting_roles = old_roles.select { |r| r.in? TWG4::CONFIG[:granting_roles] }
      new_nongranting_roles + old_granting_roles
    else
      old_roles
    end
  end

end
