module UsersHelper
  def reset_mock_exam_option
    ['activated'].include?(user.status) ? 'deactivated' : 'activated'
  end

  def changed_status(user)
    ['activated'].include?(user.status) ? 'deactivated' : 'activated'
  end

  def changed_status_link_text(user)
    ['activated'].include?(user.status) ? 'Deactivate' : 'Activate'
  end

  def resolve_layout
    case action_name
    when 'course_details'
      current_user.student? ? 'student_page' : 'dashboard'
    else
      'dashboard'
    end
  end

  def user_destroy
    del_user_email = User.find(params[:user_ids])
    user = ['tt@gradready.com.au', 'tm@gradready.com.au', 'ta@gradready.com.au', 'ts-sa@gradready.com.au']
    if user.include?(del_user_email.email)
      redirect_to user_emails_path, notice: "Destroy aborted; you can't do that!"
    end
  end

  def set_user
    @user = User.friendly.find(params[:id])
    authorize @user if @user
  end

  def find_user
    @user = User.find_by(id: params[:id])
    @user = User.friendly.find(params[:id]) unless @user.present?
    authorize @user
  end

  def display_area
    I18n.t("user.display_area.#{area}", default: area.titleize)
  end

  def area_names_for_select
    names = []
    User.areas.keys.map do |area|
      display_name = I18n.t("user.display_area.#{area}", default: area.titleize)
      names << [display_name, area]
    end
    names
  end

  def reset_mock_exam_select
    level = [["Section I", "section_1"], ["Section II (Essays)", "section_2"], ["Section III", "section_3"]]
  end
end
