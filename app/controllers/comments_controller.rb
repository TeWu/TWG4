class CommentsController < ApplicationController
  load_and_authorize_resource :album, find_by: :param
  load_and_authorize_resource :photo, through: :album
  load_and_authorize_resource :comment, through: :photo, except: :create


  def create
    @comment = @photo.comments.build content: comment_content, author: current_user
    authorize! :create, @comment

    respond_to do |format|
      if @comment.save
        format.html { redirect_to photo_comments_section_path, notice: "Comment created successfully" }
        format.json { render json: @comment, status: :created, location: [@album, @photo] }
      else
        format.html do
          flash[:new_comment] = {content: @comment.content[0..@comment.max_length]}
          redirect_to photo_comments_section_path
        end
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_with_not_permitted_in_demo_msg photo_comments_section_path and return unless is_permitted_in_demo? @comment.author

    respond_to do |format|
      if @comment.update(content: comment_content)
        format.html { redirect_to photo_comments_section_path, notice: "Comment updated successfully" }
        format.json { render json: @comment, status: :ok, location: [@album, @photo] }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_with_not_permitted_in_demo_msg photo_comments_section_path and return unless is_permitted_in_demo? @comment.author

    @comment.destroy
    respond_to do |format|
      format.html { redirect_to photo_comments_section_path, notice: "Comment deleted successfully" }
      format.json { head :no_content }
    end
  end


  private

  def comment_content
    params.require(:comment)[:content]
  end

  def photo_comments_section_path
    album_photo_path(@album, @photo, anchor: 'comments-section')
  end

end
