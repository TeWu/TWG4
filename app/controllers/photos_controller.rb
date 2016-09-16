class PhotosController < ApplicationController
  load_and_authorize_resource :album, find_by: :param
  load_and_authorize_resource :photo, through: :album, except: :create


  def show
    prepare_and_render_view :show
  end

  view_preparation :show do
    @comments = @photo.comments.accessible_by(current_ability, :show).order('created_at DESC')
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
    successful_saves_count = @photos.map(&:save).count(true)

    respond_to do |format|
      format.html do
        redirect_options = if uploaded_photos_files.blank?
                             {alert: "No photos uploaded"}
                           elsif successful_saves_count == @photos.count
                             {notice: "Photos uploaded successfully"}
                           elsif successful_saves_count > 0
                             {alert: "Some photos was not uploaded successfully"}
                           else
                             {alert: "Photos upload failed"}
                           end
        redirect_to album_path(@album, page: 'last'), redirect_options
      end
      format.json do
        if uploaded_photos_files.any?
          render :index, status: (successful_saves_count > 0 ? :created : :unprocessable_entity)
        else
          head :no_content
        end
      end
    end
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
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to @album, notice: "Photo deleted successfully" }
      format.json { head :no_content }
    end
  end


  private

  def photo_params
    params.require(:photo).permit(:description)
  end

  def uploaded_photos_files
    params[:photos_upload].try { |x| x[:files] } || []
  end

end
