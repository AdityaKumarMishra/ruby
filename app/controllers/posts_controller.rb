class PostsController < ApplicationController
  before_action :ensure_access_allowed!, only: [:edit, :update, :create, :destroy, :new]
  before_action :set_post, only: [:show, :update, :edit, :destroy]
  before_action :enable_recommender, only: [:blog_posts]
  layout 'layouts/public_page', only: [:blog_posts, :index, :show]
  before_action :check_category, only: [:index]

  def index
    @posts = Post.all
    params[:blog]="gamsat" if params[:blog].present? && params[:blog]=="gamsat-preparation-courses"
    params[:blog]="umat" if params[:blog].present? && params[:blog]=="umat-preparation-courses"
    unless params[:blog].nil? || params[:blog].blank?
      @posts = @posts.where(blog_type: Post.blog_types[params[:blog]])
      @blog = params[:blog]
    end

    if params[:blog] == "umat"
      @announcement = get_announcement('UmatReady')
      @announcement_url = get_announcement_url('UmatReady')
      if !@announcement_url.nil?
        @announcement_url = get_announcement_url('UmatReady')
      end
    elsif params[:blog] == "gamsat"
      @announcement = get_announcement('GamsatReady')
      @announcement_url = get_announcement_url('GamsatReady')
      if !@announcement_url.nil?
        @announcement_url = get_announcement_url('GamsatReady')
      end
    end

    @posts = @posts.by_month_year(params[:month], params[:year]) unless params[:month].nil? or params[:year].nil?
    @posts = @posts.search_by_name(params[:q]) unless params[:q].nil?
    category_name = params[:category].gsub('-', " ") unless params[:category].nil?

    category_name_arr= category_name.split(' ') if category_name

    where_clause = ''
    if category_name_arr
      category_name_arr.each_with_index do |s, i|
        where_clause += ' AND ' unless i == 0
        where_clause += "name ILIKE '%" + s + "%'"
      end
    end

    category_id = BlogCategory.where(where_clause).where(blog_type: BlogCategory.blog_types[params[:blog]] ).last.try(:id) unless params[:category].nil?
    @selected_category = BlogCategory.where(where_clause).where(blog_type: BlogCategory.blog_types[params[:blog]] ).last.try(:name)  unless params[:category].nil?
    @posts = @posts.includes(:blog_categories).where(blog_categories: { id: category_id}) unless params[:category].nil?
    @categories = params[:blog].nil? || params[:blog].blank? ? BlogCategory.includes(:posts).all : BlogCategory.includes(:posts).where(blog_type: BlogCategory.blog_types[params[:blog]])
    @archives = Post.list_archives(params[:blog])

    @posts = @posts.order(created_at: :desc).paginate(:page => params[:page], :per_page => 6) rescue nil
  end

  def show
    if params[:type] == "umat-preparation-courses"
      @announcement = get_announcement('UmatReady')
      @announcement_url = get_announcement_url('UmatReady')
      if !@announcement_url.nil?
        @announcement_url = get_announcement_url('UmatReady')
      end
    elsif params[:type] == "gamsat-preparation-courses"
      @announcement = get_announcement('GamsatReady')
      @announcement_url = get_announcement_url('GamsatReady')
      if !@announcement_url.nil?
        @announcement_url = get_announcement_url('GamsatReady')
      end
    end
    redirect_to posts_by_product_line_path(id: @post.friendly_id, type: @post.product_line_type) and return unless params[:type].present?
    blog_type = Post.friendly.find(params[:id]).blog_type
    @categories = BlogCategory.includes(:posts).where(blog_type: BlogCategory.blog_types[blog_type])
  end

  def edit
  end

  def blog_posts
    if params[:blog] == "vce"
      redirect_to root_path
    else
      params[:blog]="gamsat" if params[:blog].present? && params[:blog]=="gamsat-preparation-courses"
      params[:blog]="umat" if params[:blog].present? && params[:blog]=="umat-preparation-courses"
      if params[:blog] == "umat"
        @announcement = get_announcement('UmatReady')
        @announcement_url = get_announcement_url('UmatReady')
        if !@announcement_url.nil?
          @announcement_url = get_announcement_url('UmatReady')
        end
      elsif params[:blog] == "gamsat"
        @announcement = get_announcement('GamsatReady')
        @announcement_url = get_announcement_url('GamsatReady')
        if !@announcement_url.nil?
          @announcement_url = get_announcement_url('GamsatReady')
        end
      end
      unless params[:blog].nil? || params[:blog].blank?
        if not Post.blog_types.include? params[:blog]
          redirect_to blog_posts_path('gamsat') and return
        end
        @posts = Post.where(blog_type: Post.blog_types[params[:blog]]).order(created_at: :desc).paginate(:page => params[:page], :per_page => 6)
        @posts = @posts.search_by_name(params[:q]) unless params[:q].nil?
        @categories = BlogCategory.includes(:posts).where(blog_type: BlogCategory.blog_types[params[:blog]])
        @blog = params[:blog]
      end
      @archives = Post.list_archives(params[:blog])
      render action: :index
    end
  end

  def update
    if @post.update(post_params)
      flash[:notice] = 'post has been updated'
      respond_with(@post)
    else
      flash[:error] = 'there was a problem with editing that post'
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'The post has been deleted'
  end

  def create
    # category_ids = params[:post][:blog_category_ids].find_all { |i| i != '' }
    # @post = Post.new(post_params.merge(blog_category_ids: category_ids))
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to post_path(@post.id), notice: 'Post has been saved.' }
        format.json { render :index, status: :created, location: posts_path }
      else
        format.html { render :new}
        format.json { render json: @post.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def new
    @post = Post.new
  end

  def post_unsubscribe
    unsub_email = UnsubscribeEmail.find_by(user_id: params[:user_id])
    if !unsub_email.present?
      unsubscribe_email = UnsubscribeEmail.new
      unsubscribe_email.user_id = params[:user_id]
      unsubscribe_email.unsubscribe = params[:unsubscribe]
      unsubscribe_email.save
    end
    redirect_to thankyou_unsubscribe_path
  end

  private

  def ensure_access_allowed!
    user_not_authorized unless [:manager, :admin, :superadmin].include? current_user.try(:role).try(:to_sym)
  end

  def set_post
    @post = Post.friendly.find_by(slug: params[:id])
    increment_read_count!
    unless @post.present?
      redirect_to blog_posts_path('gamsat')
    end
  end

  def increment_read_count!
    @post.increment!(:read_count, 1) if @post.present?
  end

  def post_params
    params.require(:post).permit(:name, :description, :blog_type, :image, :author, :alt_text, :meta_description, :meta_keywords, blog_category_ids: [])
  end

  def enable_recommender
    @show_course_recommender = true
  end

  def check_category
    redirect_to blog_posts_path(blog: 'gamsat-preparation-courses') and return if !params[:blog].present?
  end
end
