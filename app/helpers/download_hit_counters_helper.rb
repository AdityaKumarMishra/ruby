module DownloadHitCountersHelper
	READABLE_TEXT = {
										gam_study_schedule: 'GAMSAT® Study Schedule',
										physics_formula_sheet: 'Free GAMSAT® Physics Formula Sheet',
										gam_study_syllabus: 'Free GAMSAT® Study Syllabus',
										gamsat_2022: 'GAMSAT® 2022',
										gamsat_2021: 'GAMSAT® 2022',
										what_is_gamsat: 'What is Gamsat',
										what_is_ucat: 'What is Ucat',
										gamsat_scores: 'Gamsat® Scores',
										medical_school_entry_requirements: 'Medical School Entry Requirements',
										gamsat_preparation: 'GAMSAT® Preparation',
										gamsat_section_1: 'Gamsat® Section 1',
										gamsat_section_2: 'Gamsat® Section 2',
										gamsat_section_3: 'Gamsat® Section 3',
										gamsat_free_resources: 'Free Gamsat® Preparation Materials',
										gamsat_free_practice: 'Free GAMSAT® Practice Questions and Materials',
										gamsat_example_essay: 'Free GAMSAT® Example Essays',
										free_trial: 'Free Trial',
										pathways_to_medicine: 'Pathways to Medicine',
										australian_medical_schools: 'Australian Medical Schools Overview',
										gamsat_non_science_background: 'GAMSAT Preparation for a Non-Science Background',
										gamsat_biology: 'GAMSAT Biology: How to Prepare in 2022',
										gamsat_chemistry: 'GAMSAT Physics: How to Prepare in 2022',
										gamsat_physics: 'GAMSAT Chemistry: How to Prepare in 2022',
                    					what_is_umat: 'What is Ucat',
                    					ucat_preparation: 'How to Prepare for the UCAT',
                    					ucat_structure: 'UCAT Exam Structure',
                    					ucat_parents_guide: 'UCAT Parents Guide',
                    					ucat_students_guide: 'UCAT Students Guide',
                    					ucat_vs_gamsat: 'UCAT vs GAMSAT: Everything You Need to Know',
                    					ucat_dentistry: 'UCAT Dentistry: Guide to UCAT for Dentistry'
									}.freeze

	def get_readable_text file_name
		READABLE_TEXT[file_name.to_sym]
	end

	def show_download_hit_count(file_name=nil)
		read_txt = file_name.nil? ? "Read" : ""
		read_download_txt = file_name.nil? ? "time" : "download"
		file_name ||= params[:action].to_sym
		"#{read_txt} #{pluralize((DownloadHitCounter.by_file file_name).download_count, read_download_txt)}"
	end

	def show_estimated_read_time
		"#{(DownloadHitCounter.by_file params[:action].to_sym).estimated_read_time} min read"
	end

	def find_filename file_name
    	download_no = DownloadHitCounter.by_file "free_trial"
    	return download_no.download_count
    end
end
