class BookmarksController < ApplicationController
  before_action :set_list, only: [:index, :new, :create]

  def index
    @bookmarks = @list.bookmarks.inlcudes(:list)
  end

  def new
    @bookmark = @list.bookmarks.new
    @movies = Movie.all
  end

  def create
    @bookmark = @list.bookmarks.new(bookmark_params)
    @movies = Movie.all
    if @bookmark.save
      redirect_to @list
    else
      render :new
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
    redirect_to @bookmark.list
  end

  private

  def set_list
    @list = List.find(params[:list_id])
  end

  def bookmark_params
    params.require(:bookmark).permit(:comment, :movie_id)
  end

end
