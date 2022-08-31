require 'rails_helper'

RSpec.describe CourseRecommenderUsagesController, type: :controller do
  login_admin

  describe "#index" do

    let(:course_recommender_usage) { FactoryGirl.create(:course_recommender_usage) }
    it "shows course recommender usage" do
      @skipped = CourseRecommenderUsage.create!( skip: 2, course_name: "skip")
      @incomplete = CourseRecommenderUsage.create!( incomplete: 1, course_name: "incomplete")
      @gamsat_course = CourseRecommenderUsage.create!(product_line: "GAMSAT", course_name: "GAMSAT: TEST COURSE")
      @umat_course = CourseRecommenderUsage.create!(product_line: "UMAT", course_name: "UMAT: TEST COURSE")
      @hsc_eng_course = CourseRecommenderUsage.create!(subject: "English Advanced",  product_line: "HSC", course_name: "HSC: ENG TEST COURSE")
      @hsc_math_course = CourseRecommenderUsage.create!(subject: "Mathematics Extension 1",  product_line: "HSC", course_name: "HSC: MATH TEST COURSE")
      @vce_eng_course = CourseRecommenderUsage.create!(product_line: "VCE", subject: "English", course_name: "VCE: ENG TEST COURSE")
      @vce_math_course = CourseRecommenderUsage.create!(product_line: "VCE", subject: "Mathematical Method", course_name: "VCE: MATH TEST COURSE")
      get :index
      expect(response).to be_success
    end
  end

end
