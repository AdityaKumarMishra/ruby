class TagSearchController < TagsController
  layout 'layouts/dashboard'
  before_action :authenticate_user!, except: [ :get_tag_tutors, :ticket_transfer_tags]
 
  
  
  respond_to :html, :js
  def get_tag_tutors
    tag = Tag.find_by(id: params[:tag_id])
    @options = tag.answerers if tag.present?
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end
    
  def ticket_transfer_tags
    if current_user.present? && current_user.student?
      @options = Tag.public_tags.order(:name)
    else
      ids = Tag.level_one.pluck(:id).uniq
      @options = Tag.where(parent_id: ids).order(:name)
    end
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end


  
  
  def append
    @tag = Tag.find(params[:tag_id])
    @attribute = params[:attribute]
    @div = params[:div]
  end


  
  
  


end
