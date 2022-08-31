class TagsController < ApplicationController
  layout 'layouts/dashboard'
  before_action :authenticate_user!, except: [:answerer_for_tag, :children_for_tag, :root_tags, :ticket_tags]
  before_action :ensure_access_allowed!, except: [:answerer_for_tag, :children_for_tag, :root_tags, :mcq_stem_review_videos, :ticket_tags]
  before_action :set_tag, only: [:show, :edit, :update, :destroy, :answerer_for_tag, :children_for_tag]

  respond_to :html, :js

  def index
    @tags = policy_scope(Tag)
    @filterrific = initialize_filterrific(
        @tags,
        params[:filterrific],
        select_options: {
          by_product_line: ['Gamsat', 'Umat', 'Vce', 'Hsc']
        }
    ) or return
    @tags = @filterrific.find
  end

  def children_for_tag
    #   Returns the root tags available to the user
    @tags = @tag.children
    render template: "tags/index", formats: [:json]
  end
  def children_for_tags
    tags = policy_scope(Tag).select { |tag| tag.parent_id == params[:tag_id].to_i && tag.is_public == true }
    render json: tags
  end

  def destroy
    @tag.destroy
    respond_with(@tag)
  end

  def new
    @tag = Tag.new
    authorize @tag
    respond_with(@tag)
  end

  def edit
  end

  def show
    respond_with(@tag)
  
  end

  def create
    @tag = Tag.new(tag_params)
    authorize @tag
    respond_to do |format|
      if @tag.save
        format.html { redirect_to tags_path, notice: 'Tag successfully created' }
        format.json { render :index, status: :created, location: @tag }
      else
        format.html { render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end
  def search
    @tags = Tag.search_descendant_tags(params[:search])
    @return_path = params[:return_path]
  end
  def answerer_for_tag
  end

  def update
    @tag.update(tag_params)
    respond_to do |format|
      format.html { redirect_to tags_path, notice: 'Tag was successfully updated. ' }
      format.json { render :index, status: :ok, location: @tag }
    end
  end

  def root_tags
    @tags = current_root_tags
    render template: "tags/index", formats: [:json]
  end

  def ticket_tags
    @tags = current_ticket_tags
    render template: "tags/index", formats: [:json]
  end

  def mcq_stem_review_videos
    @tag = Tag.find(params[:id])
    @videos = Vod.by_tags(@tag)
    respond_to do |format|
      format.js
    end
  end


  private
  
  def current_ticket_tags
    return @current_root_tags if @current_root_tags
    @ticket_tags = policy_scope(Tag)
    if current_user && current_user.student?
      @ticket_tags = @ticket_tags
    else
      @ticket_tags = @ticket_tags.where(is_public: true).order(:name)
    end

    all_tags = @ticket_tags.includes(:parent).to_a
    @current_root_tags = all_tags.select { |tag| tag.parent_id.nil? || !all_tags.include?(tag.parent) }
  end

  def current_root_tags
    return @current_root_tags if @current_root_tags
    all_tags = policy_scope(Tag).includes(:parent).to_a
    @current_root_tags = all_tags.select { |tag| tag.parent_id.nil? || !all_tags.include?(tag.parent) }
  end

  def ensure_access_allowed!
    user_not_authorized unless [:tutor, :manager, :admin, :superadmin].include? current_user.try(:role).try(:to_sym) unless current_user.present? && current_user.student?
  end

  def set_tag
    @tag = Tag.find_by(id: params[:id])
    authorize @tag
  end

  def tag_params
    params.require(:tag).permit(:name, :description, :tagging_count, :parent_id, :is_public, :instruction)
  end
end
