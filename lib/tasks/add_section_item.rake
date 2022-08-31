namespace :add_section_item do
  task add_course_type: :environment do
    Section.where(sectionable_type: 'DiagnosticTest').each do |section|
      mcq_stem_ids = section.section_items.includes(:mcq_stem).where(mcq_stems: { published: true}).pluck(:mcq_stem_id).uniq
      McqStem.where(id: mcq_stem_ids).each do |mcq_stem|
        mcq_stem.mcqs.each do |mcq|
          section_item  = SectionItem.find_or_create_by(mcq_id: mcq.id, section_id: section.id)
        end
      end
    end
  end
end
