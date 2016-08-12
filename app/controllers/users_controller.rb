class UsersController < ApplicationController
  load_and_authorize_resource

  def create
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User created successfully" }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
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
        format.html { render :edit }
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
    params.require(:user).permit(:display_name, :username, :password, :password_confirmation)
  end

end
