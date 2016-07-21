class PhotosController < ApplicationController
  before_action :set_album
  before_action :set_photo, only: [:show, :edit, :update, :destroy]


  def show
    @new_comment = Comment.new(flash[:new_comment])
    @new_comment.valid? if flash[:new_comment]
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)

    respond_to do |format|
      if @photo.save_and_add_to_album(@album)
        format.html { redirect_to [@album, @photo], notice: "Photo was successfully created." }
        format.json { render :show, status: :created, location: @photo }
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
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to @album, notice: "Photo was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  private

  def set_album
    @album = Album.find(params.require(:album_id))
  end

  def set_photo
    @photo = Photo.find(params.require(:id))
  end

  def photo_params
    params.require(:photo).permit(:image, :description)
  end

end
