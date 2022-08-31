class ExerciseReviewService < ApplicationService

	def initialize(params, current_user)
		@params = params
		@exercise = current_user.exercises.find_by(id: @params[:exercise_id])
		@current_user = current_user
	end

	def review
		question = @params[:question]
	    if @params[:ticket_id].present?
	      ticket = Ticket.find_by(id: @params[:ticket_id])
	      if @exercise.question_style.eql?(0)
	        selected_tab = ticket.try(:questionable).try(:mcq_stem)
	      else
	      	# previously was selected_tab = ticket.try(:questionable) not working for multiple view
	       selected_tab = ticket.try(:questionable).try(:mcq_stem)
	      end
	    end
	    return @exercise, question, selected_tab
	end

	def create_update_question_rating(mcq_exam_question_rating_params)
		mcq_attempt = McqAttempt.find_by(id: @params[:id])
	    stem = mcq_attempt.mcq_stem
	    rating = stem.rates.find_by(rater_id: @current_user.id)
	    if rating.nil?
	      mcq_exam_question_rating_params[:stars] = 0.0
	      mcq_exam_question_rating_params[:rater_id] = @current_user.id
	      rating = stem.rates.create(mcq_exam_question_rating_params)
	    else
	      rating.update(mcq_exam_question_rating_params)
	    end
	    return @exercise, mcq_attempt, rating
	end

	def mcq_exam_question_rating
	    mcq_attempt = McqAttempt.find_by(id: @params[:id])
	    rating = nil
	    if mcq_attempt.present?
	      stem = mcq_attempt.mcq_stem
	      rating = stem.rates.find_by(rater_id: @current_user.id)
	      rating = stem.rates.new if rating.nil?
	    end
	    return @exercise, mcq_attempt, rating
	end

	def exercise_review_videos
    mcq_attempt = McqAttempt.find(@params[:id])
    if @current_user.has_video_feature
      tags = @current_user.current_feature_tags('VideoFeature') & mcq_attempt.mcq.tags
      @videos = Vod.by_tags(tags)
    else
      @no_video_access = true
    end
    type = 'Videos'
    return @exercise, @videos, @no_video_access, type, mcq_attempt
	end

  # relevant textbook for review
	def exercise_review_textbooks
    mcq_attempt = McqAttempt.find_by(id: @params[:id])
    type = 'Textbooks'
    if mcq_attempt.present? && @current_user.has_textbook_feature
      tags = @current_user.current_feature_tags('TextbookFeature') & mcq_attempt.mcq.tags
      @textbooks = Textbook.by_tags(tags)
    else
      @no_textbook_access = true
    end
    return @exercise, mcq_attempt, type, @textbooks, @no_textbook_access
  end

  def review_exercise_questions(exercises, current_course)
    @access_limit = nil
    @no_access = false
    mcqs_count = 0
    @amount = @params[:exercise][:amount].to_i
    c_type = current_course.try(:product_version).try(:course_type)

    master_feature = @current_user.accessible_features.find_by('name LIKE?', '%McqFeature%')
    mc_qty_features = @current_user.active_enrolment_features.includes(:master_feature).where('feature_logs.qty IS NOT NULL AND master_features.name LIKE (?)', '%McqFeature%')

    @access_limit = current_course.product_version_feature_prices.where(master_feature_id: master_feature.id).last.qty
    @mcq_partial_purchase = false

    mcqs_count = Mcq.includes(:mcq_attempts).where(mcq_attempts: {id: McqAttempt.where(exercise_id: exercises.ids).ids}).count
    if @purchase_mcqs.present? && @mcq_partial_purchase && ProductVersion.course_types[c_type] == 0 && ((mcqs_count > @purchase_mcqs) || ((mcqs_count + @amount) > @purchase_mcqs))
      @no_access = true
    elsif @access_limit.present? && mc_qty_features.count <= 1 && ((mcqs_count > @access_limit) || ((mcqs_count + @amount) > @access_limit))
      @more_access = (mcqs_count + @amount) > @access_limit && mcqs_count < @access_limit

      @no_custom_access = true
      pvfp = current_course.product_version.product_version_feature_prices.find{|s| s.master_feature.mcq_feature? }
      mcq_price = (pvfp.price / pvfp.qty) * 500 if pvfp.present? && pvfp.qty.present?
      @mcq_price = ((BigDecimal.new("0.1") * mcq_price) + mcq_price).ceil if mcq_price.present?
      course_type = current_course.product_version.try(:type)
      case course_type
      when 'GamsatReady'
        @p_course_path = '/gamsat-preparation-courses#course-packages'
        @product_line = 'GAMSAT'
      when 'UmatReady'
        @p_course_path = '/umat-preparation-courses#course-packages'
        @product_line = 'UMAT'
      when 'HscReady'
        @p_course_path = '/hsc'
        @product_line = 'HSC'
      when 'VceReady'
        @p_course_path = '/vce'
        @product_line = 'VCE'
      end
    else
      @condition_first = false
      tag_ids = @params[:exercise][:tag_ids]
      difficulty = Exercise.difficulity_level_by_params(@params[:exercise][:difficulty])
      attempted_mcq_stems_ids = @current_user.mcq_attempts.includes(:exercise).where(exercises: {course_id: @current_user.active_course.try(:id)}).pluck(:mcq_stem_id).uniq

      # Return all mcqs that have not been attempted and relate to the tags the user selected
      available_ones = McqStem.includes(:tags).where(published: true, examinable: false, difficulty: difficulty, tags: { id: tag_ids }).references(:tags).where.not(id: attempted_mcq_stems_ids)
      arr_sum = Mcq.where(mcq_stem_id: available_ones.ids).count
      if available_ones.present? && arr_sum <= @amount
        @condition_first = true
        @left_questions = arr_sum
      elsif arr_sum == 0
        @left_questions = 0
      else
        @left_questions = arr_sum
      end
    end
    return @access_limit, @no_access, @amount, @mcq_partial_purchase, @purchase_mcqs, @more_access, @no_custom_access, @mcq_price, @p_course_path, @product_line, @condition_first, @left_questions
  end

end
