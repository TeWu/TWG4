class AlbumsController < ApplicationController
  load_and_authorize_resource except: [:index, :show]


  # NOTE: Called from +create+
  def index
    authorize! :index, Album
    @albums = Album.accessible_by(current_ability)
    if can? :new, Album
      @new_album = @album || Album.new(current_ability.attributes_for(:new, Album).merge(owner: current_user))
    end
  end

  # NOTE: Called from +update+
  def show
    @album = Album.find(params[:id])
    authorize! :show, @album
    authorize! :index, Photo
    @photos = @album.ordered_photos.accessible_by(current_ability).page(params[:page])
    @albums_add_photos_from = Album.accessible_by(current_ability, :show)
    @albums_add_photos_to = Album.accessible_by(current_ability, :add_existing_photo)
    @new_photo = Photo.new
  end

  def create
    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: "Album created successfully" }
        format.json { render :show, status: :created, location: @album }
      else
        format.html do
          index
          render :index
        end
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
          @edited_album = @album
          show
          render :show
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
