class CoursesFilterController < ApplicationController
  before_action :authenticate_user!, except: [:list_courses_by_city, :list_course_lessons, :list_cities, :public_course_cities]
  before_action :check_product_version, only: [:public_course_cities]
  
  def public_course_cities
    @product_version = ProductVersion.find_by(id: params['product_id'])
    @cities = Course.where(product_version_id: @product_version.id).where('enrolment_end_date >= ? OR remain_visible = ?', Time.zone.now.beginning_of_day, true).collect(&:city).uniq.compact.sort
    @course_type = params[:type]

    if params[:city].present?
      @first_city = params[:city]
      @courses = Course.where(product_version_id: @product_version.id, city: Course.cities[@first_city]).where('enrolment_end_date >= ? OR remain_visible = ?', Time.zone.now.beginning_of_day, true).order('remain_visible ASC, enrolment_end_date ASC, name ASC').select{|p| !p.enrolments_full?}
      @courses = transform_courses(@courses)
      @selected_course = @courses.first
    else
      @course = Course.find_by(id: params[:course_id])
      if @course.present?
        @first_city = @course.city
      else
        @first_city = nil
      end
      @courses = Course.where(product_version_id: @product_version.id, city: Course.cities[@first_city]).where('enrolment_end_date >= ? OR remain_visible = ?', Time.zone.now.beginning_of_day,true).order('remain_visible ASC, enrolment_end_date ASC, name ASC').select{|p| !p.enrolments_full?}
      @courses = transform_courses(@courses)
      @selected_course = @course
    end
  end

  def filtered_product_versions
    product_line = params[:product_line]
    if product_line.present?
      @options = ProductVersion.by_product_line(product_line).order(:name)
    else
      @options = ProductVersion.all.order(:name)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def filtered_transfer_courses
    product_line = params[:product_line]
    product_version = params[:product_version]
    city = params[:city]
    @active_course = Course.active_courses
    if product_line.present? && product_version.present? && city.present?
      @courses = @active_course.by_product_line(product_line).by_product_version(product_version).with_city(city).order(:name)
    elsif product_line.present? && product_version.present?
      @courses = @active_course.by_product_line(product_line).by_product_version(product_version).order(:name)
    elsif product_version.present? && city.present?
      @courses = @active_course.by_product_version(product_version).with_city(city).order(:name)
    elsif product_line.present? && city.present?
      @courses = @active_course.by_product_line(product_line).with_city(city).order(:name)
    elsif product_line.present?
      @options = ProductVersion.by_product_line(product_line).order(:name)
      @courses = @active_course.by_product_line(product_line).order(:name)
    elsif product_version.present?
      @courses = @active_course.by_product_version(product_version).order(:name)
    elsif city.present?
      @courses = @active_course.by_product_version(product_version).order(:name)
    else
      @options = ProductVersion.all.order(:name)
      @courses = Course.active_courses.order(:name)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def list_cities
    pv = ProductVersion.find(params[:product_id])
    @cities = Course.where(product_version_id: params[:product_id]).where('enrolment_end_date >= ?', Time.zone.now.beginning_of_day).collect(&:city).uniq.compact.sort
    if ProductVersion.course_types[pv.course_type] == 1
      @cities = @cities - ["Other"]
    end
    render json: @cities
  end

  def list_courses_by_city
    pv = ProductVersion.find(params[:product_id])
    @courses = if ProductVersion.course_types[pv.course_type] == 1 && AdminControl.find_by(name: 'Signup view').try(:new_view) && params[:mock] == "true"
                Course.includes(:lessons).where.not(lessons: {id: nil}).where(product_version_id: params[:product_id], city: Course.cities[params[:city]]).where('enrolment_end_date >= ?', Time.zone.now.beginning_of_day).order(:enrolment_end_date).select{|p| !p.enrolments_full?}
               else
                Course.where(product_version_id: params[:product_id], city: Course.cities[params[:city]]).where('enrolment_end_date >= ?', Time.zone.now.beginning_of_day).order(:enrolment_end_date).select{|p| !p.enrolments_full?}
               end
    @courses = [] if @courses.nil?
  end

  def list_course_lessons
    @course = Course.find(params[:course_id])
  end

  def check_product_version
    redirect_to gamsat_path if !params[:product_id].present?
  end
end
