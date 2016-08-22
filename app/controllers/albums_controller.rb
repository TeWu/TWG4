class AlbumsController < ApplicationController
  load_and_authorize_resource except: [:index, :show]


  def index
    prepare_and_render_view :index
  end

  view_preparation :index do
    authorize! :index, Album
    @albums = Album.accessible_by(current_ability)
    if can? :new, Album
      @new_album = @album || Album.new(current_ability.attributes_for(:new, Album).merge(owner: current_user))
    end
  end

  def show
    prepare_and_render_view :show
  end

  view_preparation :show do
    @album ||= Album.find(params[:id])
    authorize! :show, @album
    authorize! :index, Photo
    @albums_add_photos_from = Album.accessible_by(current_ability, :show)
    @albums_add_photos_to = Album.accessible_by(current_ability, :add_existing_photo)
    @photos = @album.ordered_photos.accessible_by(current_ability).page(params[:page])
    @photo_to_upload = @photo || Photo.new
  end

  def create
    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: "Album created successfully" }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { prepare_and_render_view :index }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to @album, notice: "Album updated successfully" }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html do
          @album_to_update = @album
          @album = nil
          prepare_and_render_view :show
        end
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @album.destroy
    respond_to do |format|
      format.html { redirect_to albums_url, notice: "Album deleted successfully" }
      format.json { head :no_content }
    end
  end


  private

  def album_params
    params.require(:album).permit(:name, :owner_id)
  end

end
