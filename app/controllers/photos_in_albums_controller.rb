class PhotosInAlbumsController < ApplicationController

  def new
    @photo_in_album = PhotoInAlbum.new
  end

  def create
    @photo_in_album = PhotoInAlbum.new(photo_in_album_params)

    respond_to do |format|
      if @photo_in_album.save
        format.html { redirect_to @photo_in_album.album, notice: "Photo was successfully added to album." }
        format.json { render :show, status: :created, location: @photo_in_album }
      else
        format.html { render :new }
        format.json { render json: @photo_in_album.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @photo_in_album = PhotoInAlbum.find(params[:id])
    @photo_in_album.destroy
    respond_to do |format|
      format.html { redirect_to @photo_in_album.album, notice: "Photo was successfully removed from album." }
      format.json { head :no_content }
    end
  end


  private

  def photo_in_album_params
    params.require(:photo_in_album).permit(:photo_id, :album_id, :display_order)
  end
end
