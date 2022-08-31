class DownloadHitCounter < ApplicationRecord
  enum file: [:gam_study_schedule , :physics_formula_sheet, :gam_study_syllabus, :gamsat_2021,
              :what_is_gamsat, :gamsat_scores, :medical_school_entry_requirements, :gamsat_preparation,
              :gamsat_section_1, :gamsat_section_2, :gamsat_section_3, :gamsat_free_resources,
              :gamsat_free_practice, :gamsat_example_essay, :free_trial, :australian_medical_schools,
              :pathways_to_medicine, :gamsat_non_science_background, :gamsat_biology, :gamsat_physics,
              :gamsat_chemistry, :what_is_ucat, :ucat_preparation, :ucat_structure, :ucat_parents_guide,
              :ucat_students_guide, :ucat_vs_gamsat, :ucat_dentistry]

  validates :download_count, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 2147483647 }
  validates :estimated_read_time, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 2147483647 }

  def self.by_file file_name
    download_hit_counter = nil

    if files.keys.include?(file_name.to_s)
      file_int_val = files[file_name]
      download_hit_counter = find_by(file: file_int_val)
      download_hit_counter = DownloadHitCounter.create(file: file_name, download_count: 0) if download_hit_counter.nil? 
    end

    download_hit_counter
  end
end
