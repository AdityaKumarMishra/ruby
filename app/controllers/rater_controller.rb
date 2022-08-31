class RaterController < ApplicationController
  def create
    if user_signed_in?
      @obj = params[:klass].classify.constantize.find(params[:id])
      already_present_rate = @obj.rates.find_by(rater_id: current_user.id)
      score = get_score(params[:score].to_f)
      if already_present_rate.nil? && score != 0.0
        if score < 7.0
          @low_score = true
        else
          @low_score = false
        end
        @obj.rate score, current_user, params[:dimension]
        @rate = @obj.rates.where(rater_id: current_user).last
        @rate.update(description: "")
      elsif !already_present_rate.nil?
        already_present_rate.update_attribute(:stars, score)
      end
    end
  end

  def update
    @rate = Rate.find(params[:format])
    @rate.update(description: params[:rate][:description])
    RaterMailer.rating_feedback(@rate, current_course).deliver_later if params[:rate][:description] && ENV['EMAIL_CONFIRMABLE'] != "false"
    # RaterMailer.low_rating(@rate).deliver_later if params[:rate][:description]
  end
end

def get_score(score_float)
  score_int = score_float.to_i
  decim_diff = score_float - score_int
  return decim_diff > 0.5 ? score_int + 1 : score_int + 0.5
end
