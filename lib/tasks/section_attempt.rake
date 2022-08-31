namespace :section_attempt do
  desc 'Set assessment_attempt_id in section_attempts'
  task :set_assessment_attempt_ids => :environment do
    SectionAttempt.all.each do |sa|
      if sa.assessment_attempt_id.blank? and sa.attemptable_id.present?
        sa.update_attribute(:assessment_attempt_id, sa.attemptable_id)
        puts("Success")
      end
    end
  end
  desc 'Reset assessment attempts that seem corrupted'
  task :reset_assessment_attempts=> :environment do
    AssessmentAttempt.all.select{ |aa| aa.section_attempts.count.zero?}.each do |aa|
      aa.destroy
    end
  end
end
