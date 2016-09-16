class AlbumsController < ApplicationController
  load_and_authorize_resource except: [:index, :show], find_by: :param


  def index
    prepare_and_render_view :index
  end

  view_preparation :index do
    authorize! :index, Album
    @albums = Album.order("special_purpose DESC").accessible_by(current_ability)
    @new_album = @album || Album.new(current_ability.attributes_for(:new, Album).merge(owner: current_user))
  end

  def show
    prepare_and_render_view :show
  end

  view_preparation :show do
    @album ||= Album.find_by_param!(params[:id])
    authorize! :show, @album
    authorize! :index, Photo
    photos = @album.ordered_photos.accessible_by(current_ability)
    respond_to do |format|
      format.html do
        @albums_add_photos_from = Album.accessible_by(current_ability, :show)
        @albums_add_photos_to = Album.where(special_purpose: nil).accessible_by(current_ability, :add_existing_photo)
        @photos = photos.page(page_num)
        @photo_to_upload = @photo || Photo.new
      end
      format.json { @photo_urls = photos.pluck(:id).map { |id| album_photo_url(@album, id, anchor: nil) } }
    end
  end

  def create
    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: "Album created successfully" }
        format.json { prepare_and_render_view :show, status: :created, location: @album }
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
        format.json { prepare_and_render_view :show, status: :ok, location: @album }
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

  def page_num
    params[:page] == 'last' ? @album.page_count : params[:page]
  end

end
