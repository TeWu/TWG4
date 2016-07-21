class PhotosInAlbumsController < ApplicationController
  before_action :set_album
  before_action :set_photo, only: [:create, :destroy]


  def new
    authorize! :add_existing_photo, @album
    @photo_in_album = PhotoInAlbum.new
  end

  def create
    authorize! :add_existing_photo, @album
    @photo_in_album = @album.build_photo_in_album(@photo)

    respond_to do |format|
      if @photo_in_album.save
        format.html { redirect_to @album, notice: "Photo was successfully added to album." }
        format.json { render json: @photo_in_album, status: :created, location: [@album, @photo] }
      else
        format.html { render :new }
        format.json { render json: @photo_in_album.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :remove_photo, @album
    PhotoInAlbum.get(@album, @photo).destroy
    respond_to do |format|
      format.html { redirect_to @album, notice: "Photo was successfully removed from album." }
      format.json { head :no_content }
    end
  end


  private

  def set_album
    @album = Album.find(params[:id])
  end

  def set_photo
    @photo = Photo.find(params[:photo_id])
  end

end
