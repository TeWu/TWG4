class PhotosController < ApplicationController
  load_and_authorize_resource :album, find_by: :param
  load_and_authorize_resource :photo, through: :album, except: :create


  def show
    prepare_and_render_view :show
  end

  view_preparation :show do
    @comments = @photo.comments.accessible_by(current_ability, :show).order(created_at: :desc)
    @new_comment = @photo.comments.build(flash[:new_comment])
    @new_comment.valid? if flash[:new_comment]
  end

  def create
    authorize! :add_new_photo, @album
    @photos = @album.photos.build_from_files uploaded_photos_files
    @photos.each do |photo|
      photo.owner = current_user
      authorize! :create, photo
    end
    respond_with_not_permitted_in_demo_msg @album
  end

  def update
    if @photo.update(photo_params)
      prepare_and_render_view :show, status: :ok, location: [@album, @photo]
    else
      render json: @photo.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @photo.albums.each { |album| authorize! :remove_photo, album }
    respond_with_not_permitted_in_demo_msg @album
  end


  private

  def photo_params
    params.require(:photo).permit(:description)
  end

  def uploaded_photos_files
    params[:photos_upload].try { |x| x[:files] } || []
  end

end
