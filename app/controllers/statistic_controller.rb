class StatisticController < ApplicationController
  layout 'layouts/dashboard'
  def all_tags
    @tags = Tag.includes(:mcqs).group_by { |m| m.mcqs.size }.sort_by { |k, v| v.size }
    @tags = @tags.paginate :page => params[:tags_page], :per_page => 30
  end
  def by_difficulty
    @defficulty_levels = []
    McqStem.dificulty_levels.each do |code|
      @defficulty_levels << {:code => code, :count => Mcq.by_difficulty(code).count}
    end
  end

  def mcq_stem_difficulty
    @defficulty_levels = []
    McqStem.dificulty_levels.each do |code|
      @defficulty_levels << {:code => code, :count => McqStem.with_difficulty(code).count}
    end

    @subjects_by_difficutly = []
    Course.active.each { |course|
      subjects = []
      course_pager = course.title.to_sym
      course.subjects.each { |subject|
        subjects << {
            :name=> subject.to_s,
            :easy => subject.mcq_stems.with_difficulty(:easy).count,
            :medium => subject.mcq_stems.with_difficulty(:medium).count,
            :hard => subject.mcq_stems.with_difficulty(:hard).count}
      }

      if subjects.any?
        subjects = subjects.sort_by {|obj| -(obj[:easy] + obj[:medium] +obj[:hard])}
        @subjects_by_difficutly << {
            :course => course.to_s,
            :subjects =>subjects.paginate(:page => params[course_pager]),
            :course_pager => course_pager}
      end
    }

    @tags_by_difficutly = []
      Tag.all.each { |tag|
        @tags_by_difficutly << {
            :name=> tag.to_s,
            :easy => tag.mcq_stems.with_difficulty(:easy).count,
            :medium => tag.mcq_stems.with_difficulty(:medium).count,
            :hard => tag.mcq_stems.with_difficulty(:hard).count}
      }
      @tags_by_difficutly.sort_by {|obj| -(obj[:easy] + obj[:medium] +obj[:hard])}
      @tags_by_difficutly = @tags_by_difficutly.paginate :page => params[:tags_page]
  end

  def mcq_difficulty
    @defficulty_levels = []
    McqStem.dificulty_levels.each do |code|
      @defficulty_levels << {:code => code, :count => Mcq.by_difficulty(code).count}
    end

    @subjects_by_difficutly = []
    Course.active.each { |course|
      subjects = []
      course_pager = course.title.to_sym
      course.subjects.each { |subject|
        subjects << {
            :name=> subject.to_s,
            :easy => subject.mcqs.by_difficulty(:easy).count,
            :medium => subject.mcqs.by_difficulty(:medium).count,
            :hard => subject.mcqs.by_difficulty(:hard).count}
      }

      if subjects.any?
        subjects = subjects.sort_by {|obj| -(obj[:easy] + obj[:medium] +obj[:hard])}
        @subjects_by_difficutly << {
            :course => course.to_s,
            :subjects =>subjects.paginate(:page => params[course_pager]),
            :course_pager => course_pager}
      end
    }

    @tags_by_difficutly = []
    Tag.all.each { |tag|
      @tags_by_difficutly << {
          :name=> tag.to_s,
          :easy => tag.mcqs.by_difficulty(:easy).count,
          :medium => tag.mcqs.by_difficulty(:medium).count,
          :hard => tag.mcqs.by_difficulty(:hard).count}
    }
    @tags_by_difficutly.sort_by {|obj| -(obj[:easy] + obj[:medium] +obj[:hard])}
    @tags_by_difficutly = @tags_by_difficutly.paginate :page => params[:tags_page]
  end
end
