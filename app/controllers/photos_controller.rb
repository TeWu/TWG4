class PhotosController < ApplicationController
  load_and_authorize_resource :album
  load_and_authorize_resource :photo, through: :album


  def show
    @comments = @photo.comments.accessible_by(current_ability, :show)
    @new_comment = @photo.comments.build(flash[:new_comment])
    @new_comment.valid? if flash[:new_comment]
  end

  def create
    authorize! :add_new_photo, @album
    @photo.photo_in_albums.first.display_order = @album.position_to_add_photo

    respond_to do |format|
      if @photo.save
        format.html { redirect_to [@album, @photo], notice: "Photo was successfully created." }
        format.json { render :show, status: :created, location: [@album, @photo] }
      else
        format.html { render :new }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to [@album, @photo], notice: "Photo was successfully updated." }
        format.json { render :show, status: :ok, location: [@album, @photo] }
      else
        format.html { render :edit }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @photo.albums.each { |album| authorize! :remove_photo, album }
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to @album, notice: "Photo was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  private

  def photo_params
    params.require(:photo).permit(:image, :description)
  end

end
