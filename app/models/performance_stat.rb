class PerformanceStat < ApplicationRecord
  belongs_to :user
  belongs_to :tag
  belongs_to :performable, polymorphic: true
  validates :tag_id, uniqueness: { scope: [:performable_type, :performable_id, :user_id] }


  scope :tag_filter, -> (tag_ids) { where(tag_id: tag_ids ) }

  scope :performable_type, -> (type) { where(performable_type: type ) }

  scope :performable_filter, -> (ids) { where(performable_id: ids ) }

  after_create :update_user_stats


  def self.dedupe
    # find all models and group them on keys which should be common
    grouped = all.group_by{|performance_stat| [performance_stat.performable_type,performance_stat.performable_id,performance_stat.tag_id,performance_stat.user_id] }
    grouped.values.each do |duplicates|
      # the first one we want to keep right?
      first_one = duplicates.shift # or pop for last one
      # if there are any more left, they are duplicates
      # so delete all of them
      duplicates.each{|double|
      double.destroy
      } # duplicates can now be destroyed
    end
  end

  def update_user_stats
    user = self.user
    tag = Tag.find(self.tag_id)

    type = self.performable_type

    if type == "Vod"
      tag_ids = user.current_feature_tags('VideoFeature')
      vods = Vod.where(published: true).includes(:taggings).where(taggings: { tag_id: tag_ids })
    else
      attd_feature = user.accessible_features.find_by('name LIKE?', '%AttendanceTutorialsFeature%')
      docx_feature = user.accessible_features.find_by('name LIKE?', '%DocumentsFeature%')
      text_feature = user.accessible_features.find_by('name LIKE?', '%TextbookFeature%')

      if attd_feature.present?
        tag_ids = user.current_feature_tags('AttendanceTutorialsFeature')
      elsif docx_feature.present?
        tag_ids = user.current_feature_tags('DocumentsFeature')
      else
        tag_ids = user.current_feature_tags('TextbookFeature')
      end

      if user.active_course.textbooks.present? && tag_ids.present?
        textbooks = Textbook.includes(:taggings).where('textbooks.id IN(?) OR taggings.tag_id IN(?)', user.active_course.textbooks.pluck(:id), tag_ids).references('taggings').order(:title)
      else
        textbooks = Textbook.includes(:taggings).where(taggings: {tag_id: tag_ids}).order(:title)
      end

      textbooks = textbooks.where('for_textbook IS true OR for_textbook_slide IS true')


    end


    all_tags = tag.self_and_ancestors
    ActiveRecord::Base.connection_pool.with_connection do
      all_tags.each do |t|
        if type == "Vod"
          stuent_stat = user.student_subject_performance(t, vods, user.id)
          average_stat = user.avg_subject_performance(t, vods)
        else
          stuent_stat = user.student_subject_performance(t, textbooks, user.id)
          average_stat = user.avg_subject_performance(t, textbooks)
        end
        my_stat = user.user_stats.viewable_type(type).find_by(tag_id: t.id)
        if my_stat.present?

          my_stat.update(stuent_stat: stuent_stat , average_stat: average_stat)
        else
          user.user_stats.create(tag_id: t.id, viewable_type: type, stuent_stat: stuent_stat, average_stat: average_stat)
        end

        # Commentout below 2 line, due to deadlock issue
        # We will fix when optimize the code
        # all_user_stat = UserStat.viewable_type(type).where(tag_id: t.id)
        # all_user_stat.update_all(average_stat: average_stat)
      end
    end
  end


  def self.vdo_overall_per(vods, user_id)
    vod_ids = vods.uniq.pluck(:id)
    user_count = User.find(user_id).performance_stats.performable_type("Vod").performable_filter(vod_ids).count
    total_count = vod_ids.count
    res = (user_count.to_f / total_count) * 100
    res.round(2)
  end

  def self.tb_overall_per(textbooks, user_id)
    tb_ids = textbooks.pluck(:id)
    user_count = User.find(user_id).performance_stats.performable_type("Textbook").performable_filter(tb_ids).count
    total_count = tb_ids.count
    res = (user_count.to_f / total_count) * 100
    res.round(2)
  end

end
