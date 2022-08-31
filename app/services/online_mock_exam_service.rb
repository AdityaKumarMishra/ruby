class OnlineMockExamService
  class << self

    def calculate_section_percentile(sa)
      if sa.assessment_attempt.present? && sa.assessment_attempt.assessable_type == "OnlineMockExam"
        if (sa.section.title.include?("Section I") || sa.section.sectionable.title.include?("Section I")) &&  sa.section.position == 1
          sa.percentile = ((ome_sec1_number_of_below_rank(sa) + ome_sec1_number_of_same_rank(sa)).to_f) / ome_sec1_total_attempts(sa) * 100
        else
          sa.percentile = ((ome_sec3_number_of_below_rank(sa) + ome_sec3_number_of_same_rank(sa)).to_f) / ome_sec3_total_attempts(sa) * 100
        end
      end
      sa.save
    end

    def ome_ids
      OnlineMockExam.where(published: true).pluck(:id)
    end

    def assessable(sa)
      sa.assessment_attempt.assessable_id
    end

    def ome_sec1_ids
      SectionAttempt.joins(:assessment_attempt,:section).where("assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN(?) AND sections.position =? ", ome_ids, 1).pluck(:section_id).uniq
    end

    def ome_sec3_ids
      SectionAttempt.joins(:assessment_attempt,:section).where("assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN(?) AND sections.position =? ", ome_ids, 2).pluck(:section_id).uniq
    end

    def ome_sec1_number_of_below_rank(sa)
      SectionAttempt.joins(:assessment_attempt).where("assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND section_attempts.section_id IN (?) AND section_attempts.mark < ?", assessable(sa), ome_sec1_ids, sa.mark).count
    end

    def ome_sec1_number_of_same_rank(sa)
      SectionAttempt.joins(:assessment_attempt).where("assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND section_attempts.section_id IN (?) AND section_attempts.mark = ?", assessable(sa), ome_sec1_ids, sa.mark).count
    end

    def ome_sec3_number_of_below_rank(sa)
      SectionAttempt.joins(:assessment_attempt).where("assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND section_attempts.section_id IN (?) AND section_attempts.mark < ?", assessable(sa), ome_sec3_ids, sa.mark).count
    end

    def ome_sec3_number_of_same_rank(sa)
      SectionAttempt.joins(:assessment_attempt).where("assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND section_attempts.section_id IN (?) AND section_attempts.mark = ?", assessable(sa), ome_sec3_ids, sa.mark).count
    end

    def ome_sec1_total_attempts(sa)
      SectionAttempt.joins(:assessment_attempt).where("assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND section_attempts.section_id IN (?)", assessable(sa), ome_sec1_ids).count
    end

    def ome_sec3_total_attempts(sa)
      SectionAttempt.joins(:assessment_attempt).where("assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND section_attempts.section_id IN (?)", assessable(sa), ome_sec3_ids).count
    end

  end
end