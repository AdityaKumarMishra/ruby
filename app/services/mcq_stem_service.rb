class McqStemService < ApplicationService

	def initialize(id, filterrific, filterrific_params)
		@mcq_stem = McqStem.find_by(id: id) if id.present?
		@filterrific = filterrific
		@filterrific_params = filterrific_params if filterrific_params.present?
	end

	def index(request_format, page, is_paginate)
		if request_format == 'xlsx'
			return get_all_stems_xls_data
		else
			return get_stems(page,is_paginate)
		end
	end

	private

	def get_all_stems_xls_data
		ids = @filterrific.find.pluck(:id)
      	sql = "SELECT DISTINCT mcq_stems.id, mcq_stems.published, mcq_stems.title, mcq_stems.difficulty, mcq_stems.created_at, mcq_stems.updated_at, count(DISTINCT mcqs.*) AS mcq_count, array_agg(DISTINCT CONCAT ( rates.id, '|', rates.stars)) AS all_stars, array_remove(array_agg(DISTINCT online_exams.title), NULL) AS exam_titles, array_remove(array_agg(DISTINCT diagnostic_tests.title), NULL) AS test_titles, array_remove(array_agg(DISTINCT tags.name), NULL) AS tag_names, mcq_stems.work_status, mcq_stems.work_status_updated_at,mcq_stems.status, CONCAT(reviewer.first_name, ' ', reviewer.last_name) AS reviewer, CONCAT(reviewer2.first_name, ' ', reviewer2.last_name) AS reviewer2,CONCAT(author.first_name, ' ', author.last_name) AS author,CONCAT(video_explainer.first_name, ' ', video_explainer.last_name) AS video_explainer,CONCAT(video_reviewer.first_name, ' ', video_reviewer.last_name) AS video_reviewer, mcq_stems.pool, mcq_stems.similarity_score, COUNT(mcq_videos.*) AS mcq_videos_count, count(case when mcq_videos.published = TRUE then 1 else null end) as published_videos_count FROM mcq_stems LEFT JOIN mcqs ON mcqs.mcq_stem_id = mcq_stems.id LEFT JOIN mcq_videos ON mcq_videos.mcq_id = mcqs.id LEFT JOIN section_items ON section_items.mcq_id = mcqs.id LEFT JOIN sections ON sections.id = section_items.section_id LEFT JOIN online_exams ON online_exams.id = sections.sectionable_id AND sections.sectionable_type = 'OnlineExam' LEFT JOIN diagnostic_tests ON diagnostic_tests.id = sections.sectionable_id AND sections.sectionable_type = 'DiagnosticTest' LEFT JOIN rates ON rates.rateable_id = mcq_stems.id AND rates.rateable_type = 'McqStem' LEFT JOIN taggings ON taggings.taggable_id = mcq_stems.id AND taggings.taggable_type = 'McqStem' LEFT JOIN users AS reviewer ON reviewer.id = mcq_stems.reviewer_id LEFT JOIN users AS author ON author.id = mcq_stems.author_id LEFT JOIN users AS reviewer2 ON reviewer2.id = mcq_stems.reviewer2_id LEFT JOIN users AS video_explainer ON video_explainer.id = mcq_stems.video_explainer_id LEFT JOIN users AS video_reviewer ON video_reviewer.id = mcq_stems.video_reviewer_id INNER JOIN tags ON taggings.tag_id = tags.id WHERE mcq_stems.id IN ("+ids.join(',')+") GROUP BY mcq_stems.title, mcq_stems.difficulty, mcq_stems.created_at, mcq_stems.updated_at, mcq_stems.id, reviewer.first_name,reviewer.last_name, author.first_name,author.last_name, reviewer2.first_name,reviewer2.last_name, video_explainer.first_name,video_explainer.last_name, video_reviewer.first_name,video_reviewer.last_name ORDER BY mcq_stems.title"
        @mcq_stems = ActiveRecord::Base.connection.exec_query(sql)
        @mcqs = Mcq.where(mcq_stem_id: @filterrific.find.ids)
      	@mcqs, @mcq_stems = exam_mcqs(@mcqs, @mcq_stems) if @filterrific_params.present? && @filterrific_params[:with_pool] == '1'
        return @mcq_stems, nil
	end

	def get_stems(page,is_paginate)
		@mcq_stems = @filterrific.find.order(:id)
		if is_paginate
			@mcq_stems = @mcq_stems.paginate(page: page || 1, per_page: 10)
		end
      	@mcqs = Mcq.where(mcq_stem_id: @filterrific.find.ids)
      	@mcqs, @mcq_stems = exam_mcqs(@mcqs, @mcq_stems) if @filterrific_params.present? && @filterrific_params[:with_pool] == '1'
      	return @mcq_stems, @mcqs, @mcqs.joins(:mcq_stem).group('mcq_stems.work_status').count
	end

	def current_user
		@current_user
	end
end
