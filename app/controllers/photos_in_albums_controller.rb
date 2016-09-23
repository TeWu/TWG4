class PhotosInAlbumsController < ApplicationController
  before_action :set_album
  before_action :set_photo, only: [:create, :destroy]


  def create
    authorize! :add_existing_photo, @album
    @photo_in_album = @album.build_photo_in_album(@photo)

    respond_with_not_permitted_in_demo_msg and return unless is_permitted_in_demo? @album.owner

    if @photo_in_album.save
      render json: @photo_in_album, status: :created, location: [@album, @photo]
    else
      render json: @photo_in_album.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :remove_photo, @album

    respond_with_not_permitted_in_demo_msg @album and return unless is_permitted_in_demo? @album.owner

    PhotoInAlbum.get(@album, @photo).destroy
    respond_to do |format|
      format.html { redirect_to @album, notice: "Photo removed from album successfully" }
      format.json { head :no_content }
    end
  end

  def photo_ids
    authorize! :show, @album
    ids = PhotoInAlbum.where(album: @album).pluck(:photo_id)
    render json: {ids: ids}
  end

  private

  def set_album
    @album = Album.find_by_param!(params.require(:id))
  end

  def set_photo
    @photo = Photo.find(params.require(:photo_id))
  end

end
