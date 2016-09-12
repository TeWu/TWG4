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
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User deleted successfully" }
      format.json { head :no_content }
    end
  end


  private

  def user_params
    params.require(:user).permit(:display_name, :username, :password, :password_confirmation, roles: [])
  end

end
