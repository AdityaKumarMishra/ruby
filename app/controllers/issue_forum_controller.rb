class IssueForumController < ApplicationController
  before_action :check_user, only: [:show]
  # before_action :authenticate_user!, only: [:show]
  SUBFORUM_LIMIT = 20

  # layout 'issues'
  layout :resolve_layout

  # layout 'issues', only: :show
  # layout 'issue_lists', only: :list

  def list
    if params.include? :id
      @sort_options = options_for_sort_by
      sort_by = params[:sort_by]
      # If we were given an ID, it's a specific tag subforum
      tag = Tag.find(params[:id])
      authorize tag
      # List all the tickets we have access to
      # Note we can't use .order here because tag.child_tickets returns an array
      # Note we can't also use filterific to filter an array
      tickets = filter_tickets(tag, sort_by)

      @default_tag = tag

      # If the current forum has more than this many items,
      # we split the current forum into subforums and list them.
      # Otherwise, show a list of issue tickets
      if tickets.size > SUBFORUM_LIMIT
        @subforums = tag.children.order(name: :asc)
        @title = "Ticket Subcategories for #{tag.name}"
        if @subforums.present?
          render 'issue_forum/subforum_list'
        else
          redirect_to root_path
        end
      else
        @tickets = tickets
        @title = "Tickets for #{tag.name}"
        render 'issue_forum/ticket_list'
      end

    elsif params.include?(:content_id) && params.include?(:content_type)
      authorize Ticket
      @sort_options = options_for_sort_by
      sort_by = params[:sort_by]
      # If we were given content data, render a list of tickets for the particular content
      model = params[:content_type].constantize
      @content = model.find(params[:content_id])
      @tickets = @content.tickets.where('asker_id =? OR public = true', current_user.id)
      @given_id = params[:given_id]
      @given_type = params[:given_type]

      @title = "Tickets for #{@content.name_human} #{@content.id}: #{@content.title.titlecase}"
      render 'issue_forum/ticket_list'
    else
      # Otherwise it's the root level, and we always show a subforum list here
      # Note we can't use .order here because policy_scope(Tag) returns an array
      @subforums = policy_scope(Tag).select { |tag| tag.parent == nil }.sort_by(&:name)
      render 'issue_forum/subforum_list'
    end

  end

  def get_clarity
    respond_to do |format|
      format.html { render :nothing => true }
      format.js { render :get_clarity, layout: false }
    end
  end

  def show
    if params[:content].present?
      flash[:notice] = "The question you are looking for is not available"
    end
    @question = Ticket.find_by(id: params[:id])
    if @question.present?
      authorize @question
    else
      redirect_to root_path
    end
  end

  def options_for_sort_by
    return [
      ['Answered Question', 'answered_question'],
      ['Unanswered Question', 'unanswered_question'],
      ['Date (Newest first)', 'created_at_new'],
      ['Date (Oldest first)', 'created_at_old']
    ]
  end

  # filter tickets by comparing 'sort_by value' with 'options_for_sort_by'
  def filter_tickets(tag, sort_by)
    return tag.child_tickets.select {|ticket| ticket.has_access?(current_user)}.sort_by do |ticket|
      # by default if nil or option = 0
      if(sort_by.nil?||sort_by == @sort_options[0][1])
        #sort by anwered questions first
        [ticket.ticket_answers.any? ? 0 : 1]
      elsif(sort_by == @sort_options[1][1])
        #sort by unanwered questions first
        [ticket.ticket_answers.any? ? 1 : 0]
      elsif(sort_by == @sort_options[2][1])
        #sort by newest questions first
        [Time.now - ticket.created_at]
      elsif(sort_by == @sort_options[3][1])
        #sort by oldest questions first
        [ticket.created_at]
      end
    end
  end

  def resolve_layout
    case action_name
    when 'show', 'list'
      current_user.present? && current_user.student? ? 'student_page' : 'issues'
    else
      'issues'
    end
  end

  def check_user
    ticket = Ticket.find_by(id: params[:id])
    user = User.find_by(email: ticket.email) if ticket.present?
    if user.present?
      authenticate_user!
    end
  end
end
