class CommentsController < ApplicationController
  load_and_authorize_resource :album
  load_and_authorize_resource :photo, through: :album
  load_and_authorize_resource :comment, through: :photo, except: :create


  def create
    @comment = @photo.comments.build content: comment_content, author: current_user
    authorize! :create, @comment

    respond_to do |format|
      if @comment.save
        format.html { redirect_to [@album, @photo], notice: "Comment created successfully" }
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
        format.html { redirect_to [@album, @photo], notice: "Comment updated successfully" }
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
      format.html { redirect_to [@album, @photo], notice: "Comment deleted successfully" }
      format.json { head :no_content }
    end
  end


  private

  def comment_content
    params.require(:comment).require(:content)
  end

end
