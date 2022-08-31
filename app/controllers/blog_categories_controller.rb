class BlogCategoriesController < ApplicationController
  layout 'layouts/dashboard'
  before_action :set_blog_category, only: [:show, :edit, :destroy, :update, :list_posts]
  before_action :ensure_access_allowed!

  def index
    @blog_categories = BlogCategory.all.order([:blog_type, name: :asc])
    @filterrific = initialize_filterrific(
        @blog_categories,
        params[:filterrific],
        select_options: {
          by_product_line: {"Gamsat"=>0, "Umat"=>1, "Vce"=>2, "Hsc"=>3}
        }
    ) or return
    @blog_categories = @filterrific.find
  end

  def show
    @posts = @blog_category.posts.paginate(:page => params[:page], per_page: 6)
  end

  def new
    @blog_category = BlogCategory.new
  end

  def create
    @blog_category = BlogCategory.new(blog_category_params)
    respond_to do |format|
      if @blog_category.save
        format.html { redirect_to blog_categories_path, notice: 'Category has been saved.' }
        format.json { render :index, status: :created, location: blogs_path }
      else
        format.html { render :index}
        format.json { render json: @blog_category.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def update
    @blog_category.update(blog_category_params)
  end

  def edit
  end

  def destroy
    @blog_category.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to blog_categories_path }
      format.json { head :no_content }
    end
  end

  private

  def ensure_access_allowed!
    user_not_authorized unless [:manager, :admin, :superadmin].include? current_user.try(:role).try(:to_sym)
  end

  def blog_category_params
    params.require(:blog_category).permit(:name, :blog_type)
  end

  def set_blog_category
    @blog_category = BlogCategory.friendly.find(params[:id])
  end
end
