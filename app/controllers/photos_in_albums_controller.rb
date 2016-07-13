class PhotosInAlbumsController < ApplicationController
  before_action :set_photo_in_album, only: [:show, :edit, :update, :destroy]

  # GET /photo_in_albums
  # GET /photo_in_albums.json
  def index
    @photo_in_albums = PhotoInAlbum.all
  end

  # GET /photo_in_albums/1
  # GET /photo_in_albums/1.json
  def show
  end

  # GET /photo_in_albums/new
  def new
    @photo_in_album = PhotoInAlbum.new
  end

  # GET /photo_in_albums/1/edit
  def edit
  end

  # POST /photo_in_albums
  # POST /photo_in_albums.json
  def create
    @photo_in_album = PhotoInAlbum.new(photo_in_album_params)

    respond_to do |format|
      if @photo_in_album.save
        format.html { redirect_to @photo_in_album, notice: 'Photo in album was successfully created.' }
        format.json { render :show, status: :created, location: @photo_in_album }
      else
        format.html { render :new }
        format.json { render json: @photo_in_album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photo_in_albums/1
  # PATCH/PUT /photo_in_albums/1.json
  def update
    respond_to do |format|
      if @photo_in_album.update(photo_in_album_params)
        format.html { redirect_to @photo_in_album, notice: 'Photo in album was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo_in_album }
      else
        format.html { render :edit }
        format.json { render json: @photo_in_album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photo_in_albums/1
  # DELETE /photo_in_albums/1.json
  def destroy
    @photo_in_album.destroy
    respond_to do |format|
      format.html { redirect_to photo_in_albums_url, notice: 'Photo in album was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo_in_album
      @photo_in_album = PhotoInAlbum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_in_album_params
      params.require(:photo_in_album).permit(:photo_id, :album_id, :display_order)
    end
end
