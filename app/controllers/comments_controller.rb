class CommentsController < ApplicationController
  before_action :set_album_and_photo
  before_action :set_comment, only: [:edit, :update, :destroy]


  def create
    @comment = @photo.comments.build content: comment_content, author: current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to [@album, @photo], notice: "Comment was successfully created." }
        format.json { render json: @comment, status: :created, location: [@album, @photo] }
      else
        format.html do
          flash[:new_comment] = {content: @comment.content[0..@comment.max_length]}
          redirect_to [@album, @photo]
        end
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(content: comment_content)
        format.html { redirect_to [@album, @photo], notice: "Comment was successfully updated." }
        format.json { render json: @comment, status: :ok, location: [@album, @photo] }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to [@album, @photo], notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  private

  def comment_content
    params.require(:comment)[:content]
  end

  def set_comment
    @comment = Comment.find(params.require(:id))
  end

  def set_album_and_photo
    @album = Album.find(params.require(:album_id))
    @photo = Photo.find(params.require(:photo_id))
  end

end
