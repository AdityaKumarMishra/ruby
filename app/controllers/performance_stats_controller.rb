class PerformanceStatsController < ApplicationController
  before_action :authenticate_user!
  # before_action :check_video_already_seen, only: [:create]
  layout 'layouts/student_page'
  include PerformanceConcern

  def index
    if current_course.nil?
      redirect_to "/dashboard/home"
    else
      user = current_user
      pl = current_course.product_version.product_line.name
      pv_type = ProductVersion.course_types[current_course.product_version.course_type]
      if pv_type == 2 || pv_type == 3 || pv_type == 9
        tag = Tag.find(324)
      elsif  pl == "gamsat"
        tag = Tag.find(246)
      else
        tag = Tag.find(30)
      end
      @vods = policy_scope(Vod)
      @textbooks = policy_scope(Textbook).where('for_textbook IS true OR for_textbook_slide IS true')
      @essays_responses = current_user.essay_responses.includes(essay_tutor_response: [staff_profile: [:staff]]).with_status("Marked")
      @all_essays_responses = EssayResponse.includes(essay_tutor_response: [staff_profile: [:staff]]).with_status("Marked")
      @ol_exams = current_user.assessment_attempts.where(assessable_type: 'OnlineExam')
      @student_stats = current_user.fetch_user_performance_stat(tag, current_course.id, @vods , @textbooks)

      @topicss= current_user.recommended_topics_count(current_user, tag, @ol_exams)
      @vdo_overall_per = @student_stats.viewable_type("Vod").find_by(tag_id: tag.id).stuent_stat
      @tb_overall_per = @student_stats.viewable_type("Textbook").find_by(tag_id: tag.id).stuent_stat
      @overall_per = ((@vdo_overall_per + @tb_overall_per) / 2).round(2)

      @vdo_avg__per = @student_stats.viewable_type("Vod").find_by(tag_id: tag.id).average_stat
      @tb_avg__per = @student_stats.viewable_type("Textbook").find_by(tag_id: tag.id).average_stat
      @avg_overall_per = ((@vdo_avg__per + @tb_avg__per) / 2).round(2)

      @essay_overall = current_user.essay_performance(@essays_responses)
      @essay_average = current_user.essay_performance(@all_essays_responses)

      @mcq_overall = current_user.fetch_user_mcq_stats(tag.id).score
      #@mcq_average = current_user.avg_mcq_stats(tag.id)
      @mcq_average = 59

      @exam_overall = current_user.user_exam_stat(tag, @ol_exams)
      #@exam_average = current_user.exam_avg_stat(tag)
      @exam_average = 55.19

      @sec_2_overall = ((@mcq_overall + @essay_overall + @exam_overall) / 3).round(2)
      @sec_2_average = ((@mcq_average + @essay_average + @exam_average) / 3).round(2)

      @mcqs = []

      @result = performance_data_drilldown(tag,@vods,@textbooks)
      @result = @result.to_json
      @section_2_result = sec2_performance_data_drilldown(tag,@essays_responses,@mcqs , @ol_exams,@all_essays_responses)
      @section_2_result = @section_2_result.to_json
    end
  end

  def create
    if current_user.performance_stats.where(performable_type: params[:performable_type], performable_id: params[:performable_id]).present?
      result = 'false'
    else
      performable = if params[:performable_type] == 'Vod'
                    Vod.find(params[:performable_id])
                  else
                    Textbook.find(params[:performable_id])
                  end
      performable_hash = []
      if performable.tags.count > 1
        performable.tags.each do |tag|
          performable_hash << {tag_id: tag.id, user_id: current_user.id, performable: performable} unless tag.children.present?
        end
      else
        performable.tags.each do |tag|
          performable_hash << {tag_id: tag.id, user_id: current_user.id, performable: performable}
        end
      end
      result = PerformanceStat.create(performable_hash)
    end

    render text: result
  end

  private
  def check_video_already_seen
    render text: 'false' if current_user.performance_stats.where(performable_type: params[:performable_type], performable_id: params[:performable_id]).present?
  end

  def performance_data_drilldown(tag, vods, textbooks)
    colors = [
      {:linearGradient=>{:x1=>0, :y1=>100, :x2=>0, :y2=>1}, :stops=>[[0, "rgb(147, 147, 147)"], [1, "rgb(183, 183, 183)"]]},
      {:linearGradient=>{:x1=>0, :y1=>100, :x2=>0, :y2=>1}, :stops=>[[0, "rgb(204, 6, 9)"], [1, "rgb(244, 26, 37)"]]},
      {:linearGradient=>{:x1=>0, :y1=>100, :x2=>0, :y2=>1}, :stops=>[[0, "rgb(12, 167, 0)"], [1, "rgb(14, 194, 0)"]]}
    ]
    vod_col = @vdo_overall_per >= @vdo_avg__per ? colors[2] : colors[1]
    tb_col = @tb_overall_per >= @tb_avg__per ? colors[2] : colors[1]
    data = [{
          id: 'overall_per',
          name: 'Your Performance',

          data: [
            {name: 'Video', y: @vdo_overall_per , color: vod_col, drilldown: 'video'},
            {name: 'TextBook', y: @tb_overall_per , color: tb_col, drilldown: 'textbook'},
            ]
          },
          {
          id: 'overall_per1',
          name: 'Average GR student',

          data: [
             {name: 'Video', y: @vdo_avg__per , color: colors[0], drilldown: 'video1'},
            {name: 'TextBook', y: @tb_avg__per , color: colors[0], drilldown: 'textbook1'},
            ]
          },
          {
          id: 'video',
          name: 'Your Performance',


          data: [
            {name: tag.name, y: @vdo_overall_per , color: vod_col, drilldown: 'vdo_' + tag.name.parameterize("-")},

            ]
          },
          {
           id: 'video1',
          name: 'Average GR student',

          data: [
            {name: tag.name, y: @vdo_avg__per , color: colors[0], drilldown: 'vdo_' + tag.name.parameterize("-") + "1"},

            ]
          },
          {
            id: 'textbook',
            name: 'Your Performance',


            data: [
              {name: tag.name, y: @tb_overall_per , color: tb_col, drilldown: 'txt_' + tag.name.parameterize("-")},

              ]
            },
            {
             id: 'textbook1',
            name: 'Average GR student',

            data: [
              {name: tag.name, y: @tb_avg__per , color: colors[0], drilldown: 'txt_' + tag.name.parameterize("-") + "1"},

              ]
            }]
    tag.self_and_descendants.each do |hv|

      vod_data = get_vdo_performance_data(hv, vods)
      data <<  vod_data[0]
      data <<  vod_data[1]

      # data << get_vdo_average_data(hv, vods)

      txtbook_data = get_txt_performance_data(hv, textbooks)
      data <<  txtbook_data[0]
      data <<  txtbook_data[1]
      # data << get_txt_average_data(hv, textbooks)
    end
    data = data.compact.sort_by { |hsh| hsh[:value] }
    data
  end



  def sec2_performance_data_drilldown(tag, essays, mcqs , ol_exams, all_essays)
    colors = [
      {:linearGradient=>{:x1=>0, :y1=>100, :x2=>0, :y2=>1}, :stops=>[[0, "rgb(147, 147, 147)"], [1, "rgb(183, 183, 183)"]]},
      {:linearGradient=>{:x1=>0, :y1=>100, :x2=>0, :y2=>1}, :stops=>[[0, "rgb(204, 6, 9)"], [1, "rgb(244, 26, 37)"]]},
      {:linearGradient=>{:x1=>0, :y1=>100, :x2=>0, :y2=>1}, :stops=>[[0, "rgb(12, 167, 0)"], [1, "rgb(14, 194, 0)"]]}
    ]

    essay_col = @essay_overall >= @essay_average ? colors[2] : colors[1]
    mcq_col = @mcq_overall >= @mcq_average ? colors[2] : colors[1]
    exam_col = @exam_overall >= @exam_average ? colors[2] : colors[1]

    data = [{
          id: 'overall_per',
          name: 'Your Performance',

          data: [
            {name: 'MCQs', y: @mcq_overall , color: mcq_col, drilldown: 'mcq'},
            {name: 'Exams', y: @exam_overall , color: exam_col, drilldown: 'exam'},
            {name: 'Essays', y: @essay_overall , color: essay_col, drilldown: 'essay'},
            ]
          },
          {
          id: 'overall_per1',
          name: 'Average GR student',

          data: [
             {name: 'MCQs', y: @mcq_average , color: colors[0], drilldown: 'mcq1'},
            {name: 'Exams', y: @exam_average , color: colors[0], drilldown: 'exam1'},
            {name: 'Essays', y: @essay_average , color: colors[0], drilldown: 'essay1'},
            ]
          },
          {
          id: 'mcq',
          name: 'Your Performance',


          data: [
            {name: tag.name, y: @mcq_overall , color: mcq_col, drilldown: 'mcq_gm-gamsat'},

            ]
          },
          {
           id: 'mcq1',
          name: 'Average GR student',

          data: [
            {name: tag.name, y: @mcq_average , color: colors[0], drilldown: 'mcq_gm-gamsat1'},

            ]
          },
          {
            id: 'exam',
            name: 'Your Performance',


            data: [
              {name: tag.name, y: @exam_overall , color: exam_col, drilldown: 'exam_gm-gamsat'},

              ]
            },
            {
             id: 'exam1',
            name: 'Average GR student',

            data: [
              {name: tag.name, y: @exam_average , color: colors[0], drilldown: 'exam_gm-gamsat1'},

              ]
            },
          {
            id: 'essay',
            name: 'Your Performance',


            data: [
              {name: tag.name, y: @essay_overall , color: essay_col, drilldown: 'essay_gm-gamsat'},

              ]
            },
            {
             id: 'essay1',
            name: 'Average GR student',

            data: [
              {name: tag.name, y: @essay_average , color: colors[0], drilldown: 'essay_gm-gamsat1'},

              ]
            }]

    tag.self_and_descendants.each do |hv|

      mcq_data = get_mcq_performance_data(hv, mcqs)
      data <<  mcq_data[0]
      data <<  mcq_data[1]
      # data << get_mcq_average_data(hv,mcqs)
      exam_data = get_exam_performance_data(hv, ol_exams)
      data <<  exam_data[0]
      data <<  exam_data[1]
      # data << get_exam_average_data(hv,ol_exams)
    end

    essay_data = get_my_essay_performance_data(all_essays, essays)

    data <<  essay_data[0]
    data <<  essay_data[1]
    # data << get_my_essay_avg_data(all_essays, essays)
    data = data.compact.sort_by { |hsh| hsh[:value] }
    data
  end

  def get_vdo_performance_data(hv, vods)
    children = hv.children
    check_drill = children.present?
    type = "video"

    records = check_drill ? get_singl_pdata(children, type, vods) : nil

    p_data_records = records.present? ? records[0] : records

    a_data_records = records.present? ? records[1] : records


    row = {
      id: "vdo_" + hv.name.parameterize("-"),
      name: 'Your Performance',
      data: p_data_records
    }

    row2 = {
      id: "vdo_" + hv.name.parameterize("-") + "1",
      name: 'Average GR student',
      data: a_data_records
    }

    rows = [row , row2]
  end

  def get_txt_performance_data(hv, textbooks)
    children = hv.children
    check_drill = children.present? #&& amount > 0
    type = "textbook"

    records = check_drill ? get_singl_pdata(children, type, textbooks) : nil

    p_data_records = records.present? ? records[0] : records

    a_data_records = records.present? ? records[1] : records


    row = {
      id: "txt_" + hv.name.parameterize("-"),
      name: 'Your Performance',
      data: p_data_records
    }
    row2 = {
      id: "txt_" + hv.name.parameterize("-") + "1",
      name: 'Average GR student',
      data: a_data_records
    }

    rows = [row , row2]
  end

  def get_mcq_performance_data(hv,mcqs )
    children = hv.children
    check_drill = children.present?
    type = "mcq"


    records = check_drill ? get_mcq_pdata(children, type, mcqs) : nil

    p_data_records = records.present? ? records[0] : records

    a_data_records = records.present? ? records[1] : records

    row = {
      id: "mcq_" + hv.name.parameterize("-"),
      name: 'Your Performance',
      data: p_data_records
    }

    row2= {
      id: "mcq_" + hv.name.parameterize("-") + "1",
      name: 'Average GR student',
      data: a_data_records
    }

    rows = [row , row2]
  end

  def get_exam_performance_data(hv, ol_exams)
    children = hv.children
    check_drill = children.present?
    type = "exam"

    records = check_drill ? get_mcq_pdata(children, type, ol_exams) : nil

    p_data_records = records.present? ? records[0] : records

    a_data_records = records.present? ? records[1] : records


    row = {
      id: "exam_" + hv.name.parameterize("-"),
      name: 'Your Performance',
      data: p_data_records
    }

    row2 = {
      id: "exam_" + hv.name.parameterize("-") + "1",
      name: 'Average GR student',
      data: a_data_records
    }

    rows = [row , row2]

  end

  def get_e_data(all_essays , essays)
    colors = [
      {:linearGradient=>{:x1=>0, :y1=>100, :x2=>0, :y2=>1}, :stops=>[[0, "rgb(147, 147, 147)"], [1, "rgb(183, 183, 183)"]]},
      {:linearGradient=>{:x1=>0, :y1=>100, :x2=>0, :y2=>1}, :stops=>[[0, "rgb(204, 6, 9)"], [1, "rgb(244, 26, 37)"]]},
      {:linearGradient=>{:x1=>0, :y1=>100, :x2=>0, :y2=>1}, :stops=>[[0, "rgb(12, 167, 0)"], [1, "rgb(14, 194, 0)"]]}]


    type = "essay"

    name = []

    avg_name = []

    essays.pluck(:essay_id).uniq.each do |e_id|

      title = Essay.find(e_id).title


      responses = essays.where(essay_id: e_id)
      all_reponses = all_essays.where(essay_id: e_id)

      subject_performance = current_user.essay_performance(responses)
      avg_performance = current_user.essay_performance(all_reponses)

      col = subject_performance >= avg_performance ? colors[2] : colors[1]

      name <<

      { name: title,
        y:subject_performance,
        color: col,
        drilldown: nil
      }

      avg_name <<

      { name: title,
        y:avg_performance,
        color: colors[0],
        drilldown: nil
      }
    end

    all_array = []
    all_array << name
    all_array << avg_name

    d_hash = {}

    all_array.each_with_index do |k , index|
      d_hash[index] = k
    end



    d_hash

  end

  def get_e_avg_data(all_essays, essays)
        colors = [
      {:linearGradient=>{:x1=>0, :y1=>100, :x2=>0, :y2=>1}, :stops=>[[0, "rgb(147, 147, 147)"], [1, "rgb(183, 183, 183)"]]}]

    name = []
    essays.pluck(:essay_id).uniq.each do |e_id|

      title = Essay.find(e_id).title

      all_reponses = all_essays.where(essay_id: e_id)

      avg_performance = current_user.essay_performance(all_reponses)

      name <<

      { name: title,
        y:avg_performance,
        color: colors[0],
        drilldown: nil
      }
    end
    name
  end

  def get_my_essay_performance_data(all_essays , essays)

    essay_records = get_e_data(all_essays , essays)

    row = {
      id: "essay_gm-gamsat",
      name: 'Your Performance',
      data: essay_records[0]
    }

    row2 = {
      id: "essay_gm-gamsat1",
      name: 'Average GR student',
      data: essay_records[1]
    }

    rows = [row , row2]
  end


  # def get_my_essay_avg_data(all_essays , essays)
  #   row = {
  #     id: "essay_gm-gamsat1",
  #     name: 'Average GR student',
  #     data: get_e_avg_data(all_essays , essays)
  #   }
  # end

  # def get_vdo_average_data(hv, vods)
  #   children = hv.children
  #   check_drill = children.present? #&& amount > 0
  #   type = "video"
  #   row2= {
  #     id: "vdo_" + hv.name.parameterize("-") + "1",
  #     name: 'Average GR student',
  #     data: check_drill ? get_singl_adata(children, type, vods) : nil
  #   }
  # end

  def get_txt_average_data(hv, textbooks)
    children = hv.children
    check_drill = children.present? #&& amount > 0
    type = "textbook"
    row2= {
      id: "txt_" + hv.name.parameterize("-") + "1",
      name: 'Average GR student',
      data: check_drill ? get_singl_adata(children, type, textbooks) : nil
    }
  end

  # def get_mcq_average_data(hv,mcqs)
  #   children = hv.children
  #   check_drill = children.present?
  #   type = "mcq"
  #   row2= {
  #     id: "mcq_" + hv.name.parameterize("-") + "1",
  #     name: 'Average GR student',
  #     data: check_drill ? get_mcq_adata(children, type,mcqs) : nil
  #   }
  # end

  # def get_exam_average_data(hv,exams)
  #   children = hv.children
  #   check_drill = children.present?
  #   type = "exam"
  #   row2= {
  #     id: "exam_" + hv.name.parameterize("-") + "1",
  #     name: 'Average GR student',
  #     data: check_drill ? get_mcq_adata(children,type,exams) : nil
  #   }
  # end

  def get_singl_pdata(children, type, values)

    if type == "textbook"
      id_add = "txt_"
      my_stat = @student_stats.viewable_type("Textbook")
    else
      id_add = "vdo_"
      my_stat = @student_stats.viewable_type("Vod")
    end

    colors = [
      {:linearGradient=>{:x1=>0, :y1=>100, :x2=>0, :y2=>1}, :stops=>[[0, "rgb(147, 147, 147)"], [1, "rgb(183, 183, 183)"]]},
      {:linearGradient=>{:x1=>0, :y1=>100, :x2=>0, :y2=>1}, :stops=>[[0, "rgb(204, 6, 9)"], [1, "rgb(244, 26, 37)"]]},
      {:linearGradient=>{:x1=>0, :y1=>100, :x2=>0, :y2=>1}, :stops=>[[0, "rgb(12, 167, 0)"], [1, "rgb(14, 194, 0)"]]}]

    name = []
    avg_name = []
    children.all.each do |child|

      child_stat = my_stat.find_by(tag_id: child.id)

      col = child_stat.stuent_stat >= child_stat.average_stat ? colors[2] : colors[1]

      name <<

      { name: child.name,
        y:child_stat.stuent_stat,
        color: col,
        drilldown: child.children.present? ? id_add + child.name.parameterize("-") : nil
      }

      avg_name <<

      { name: child.name,
        y: child_stat.average_stat > 100 ? 100 : child_stat.average_stat,
        color: colors[0],
        drilldown: child.children.present? ? id_add + child.name.parameterize("-") + "1" : nil
      }
    end

    all_array = []
    all_array << name
    all_array << avg_name

    d_hash = {}

    all_array.each_with_index do |k , index|
      d_hash[index] = k
    end



    d_hash

  end

  def get_singl_adata(children, type, values)
    if type == "textbook"
      id_add = "txt_"
      my_stat = @student_stats.viewable_type("Textbook")
    else
      id_add = "vdo_"
      my_stat = @student_stats.viewable_type("Vod")
    end

    colors = [
      {:linearGradient=>{:x1=>0, :y1=>100, :x2=>0, :y2=>1}, :stops=>[[0, "rgb(147, 147, 147)"], [1, "rgb(183, 183, 183)"]]}]

    name = []
    children.all.each do |child|

      child_stat = my_stat.find_by(tag_id: child.id)
      name <<

      { name: child.name,
        y:child_stat.average_stat,
        color: colors[0],
        drilldown: child.children.present? ? id_add + child.name.parameterize("-") + "1" : nil
      }
    end
    name
  end

  def get_mcq_pdata(children, type, values)
    if type == "mcq"
      id_add = "mcq_"
    elsif type == "exam"
      id_add = "exam_"
    elsif type == "essay"
      id_add = "essay_"
    end

    colors = [
      {:linearGradient=>{:x1=>0, :y1=>100, :x2=>0, :y2=>1}, :stops=>[[0, "rgb(147, 147, 147)"], [1, "rgb(183, 183, 183)"]]},
      {:linearGradient=>{:x1=>0, :y1=>100, :x2=>0, :y2=>1}, :stops=>[[0, "rgb(204, 6, 9)"], [1, "rgb(244, 26, 37)"]]},
      {:linearGradient=>{:x1=>0, :y1=>100, :x2=>0, :y2=>1}, :stops=>[[0, "rgb(12, 167, 0)"], [1, "rgb(14, 194, 0)"]]}]

    name = []

    avg_name = []
    children.all.each do |child|
      if type == "mcq"
        subject_performance = current_user.fetch_user_mcq_stats(child.id).score
        avg_performance = current_user.avg_mcq_stats(child.id)
      elsif type == "exam"
        subject_performance = current_user.user_exam_stat(child, values)
        avg_performance = current_user.exam_avg_stat(child)
      end
      #### for static average performance start #####
      #unless child.children.present?
      avg_performance = get_avg_performance(child, avg_performance, type)
      #end
      ##### static average performance end #####
      col = subject_performance >= avg_performance ? colors[2] : colors[1]

      name <<

      { name: child.name,
        y:subject_performance,
        color: col,
        drilldown: child.children.present? ? id_add + child.name.parameterize("-") : nil
      }
      
      avg_name <<

      { name: child.name,
        y:avg_performance,
        color: colors[0],
        drilldown: child.children.present? ? id_add + child.name.parameterize("-")  + "1" : nil
      }


    end


    all_array = []
    all_array << name
    all_array << avg_name

    d_hash = {}

    all_array.each_with_index do |k , index|
      d_hash[index] = k
    end



    d_hash

  end

  def get_mcq_adata(children, type, values)
    if type == "mcq"
      id_add = "mcq_"
    elsif type == "exam"
      id_add = "exam_"
    elsif type == "essay"
      id_add = "essay_"
    end

    colors = [
      {:linearGradient=>{:x1=>0, :y1=>100, :x2=>0, :y2=>1}, :stops=>[[0, "rgb(147, 147, 147)"], [1, "rgb(183, 183, 183)"]]}]

    name = []
    children.all.each do |child|

      if type == "mcq"
        avg_performance = current_user.avg_mcq_stats(child.id)
      elsif type == "exam"
        avg_performance = current_user.exam_avg_stat(child)

      end

      name <<

      { name: child.name,
        y:avg_performance,
        color: colors[0],
        drilldown: child.children.present? ? id_add + child.name.parameterize("-")  + "1" : nil
      }
    end
    name
  end

end
