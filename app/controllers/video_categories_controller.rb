class VideoCategoriesController < ApplicationController
  before_action :set_video_category, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @video_categories = VideoCategory.all
    respond_with(@video_categories)
  end

  def show
    respond_with(@video_category)
  end

  def new
    @video_category = VideoCategory.new
    respond_with(@video_category)
  end

  def edit
  end

  def create
    @video_category = VideoCategory.new(video_category_params)
    @video_category.save
    respond_with(@video_category)
  end

  def update
    @video_category.update(video_category_params)
    respond_with(@video_category)
  end

  def destroy
    @video_category.destroy
    respond_with(@video_category)
  end

  private
    def set_video_category
      @video_category = VideoCategory.find(params[:id])
    end

    def video_category_params
      params.require(:video_category).permit(:name, :subject_id)
    end
end
