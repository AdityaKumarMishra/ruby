class ThankyouController < ApplicationController
  before_action :set_path, except: [:unsubscribe]
  layout :resolve_layout

  def gamsattrial
    @type = 'gamsat'
    render 'show'
  end

  def umattrial
    @type = 'umat'
    render 'show'
  end

  def gamsat
    @type = 'gamsat'
    render 'show'
  end

  def umat
    @type = 'umat'
    render 'show'
  end

  def ir
    @type = 'gamsat'
    render 'show'
  end

  private
  def set_path
    @path = if session[:previous_url].present? && (session[:previous_url].include?('/enrolments/enrol') || session[:previous_url].include?('/enrolments/custom_enrol'))
              dashboard_home_path
            else
              session[:previous_url] || dashboard_home_path
            end
  end

  def resolve_layout
    case action_name
    when 'unsubscribe'
      'blog_mailer'
    else
      'student_page'
    end
  end

end
