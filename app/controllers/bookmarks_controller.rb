class BookmarksController < ApplicationController
  before_action :authenticate_api_key
  before_action :set_bookmark, only: %i[ show update destroy ]

  # GET /bookmarks
  def index
    @bookmarks = Bookmark.all

    render json: @bookmarks
  end

  # GET /bookmarks/1
  def show
    render json: @bookmark
  end

  # POST /bookmarks
  def create
    @bookmark = Bookmark.new(bookmark_params)

    if @bookmark.save
      render json: @bookmark, status: :created, location: @bookmark
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bookmarks/1
  def update
    if @bookmark.update(bookmark_params)
      render json: @bookmark
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  # DELETE /bookmarks/1
  def destroy
    @bookmark.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookmark
      @bookmark = Bookmark.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bookmark_params
      params.require(:bookmark).permit(:title, :url)
    end

    private

    def authenticate_api_key
      # find the user based on the headers from HTTP request
      @current_key = ApiKey.find_by(
        bookmark_api_key: request.headers['X-api-key'],
        bookmark_api_token: request.headers['X-api-token']
      )
      # return error message with 403 HTTP status if there's no such user
      return render(json: { message: 'Invalid API key' }, status: 403) unless @current_key
    end
end
