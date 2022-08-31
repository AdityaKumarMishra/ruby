# == Schema Information
#
# Table name: job_applications
#
#  id                  :integer          not null, primary key
#  first_name          :string
#  last_name           :string
#  phone_number        :string
#  email               :string
#  job_application_form_id  :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#


require 'rails_helper'

message = 'Please complete field'

RSpec.describe JobApplication, type: :model do
  let(:job_application) { FactoryGirl.build(:job_application, applicant_type: "Current University Student") }
  let(:later) { FactoryGirl.create :job_application, applicant_type: "Current University Student" }
  let(:earlier) { FactoryGirl.create :job_application, applicant_type: "Current University Student" }
  let(:middle) { FactoryGirl.create :job_application, applicant_type: "Current University Student" }


  it 'has valid :job_application factory' do
    expect(job_application).to be_valid
  end

  it { expect(job_application).to belong_to :job_application_form }
  it { expect(job_application).to have_many :application_answers }
  it { expect(job_application).to have_one :address }
  it { expect(job_application).to have_one :cover_letter }
  it { expect(job_application).to have_one :resume }


  it { should validate_presence_of(:name).with_message(message) }
  it { should validate_presence_of(:phone_number).with_message(message) }
  it { should validate_length_of(:phone_number).is_at_most(15) }
  it { should validate_presence_of(:email).with_message(message) }

  it { should define_enum_for(:status) }
  it { should define_enum_for(:degree_type) }

  it "orders records by Expected Graduation Date" do
    JobApplication.delete_all
    results = JobApplication.order_by_graduation
    results.should == [earlier, middle, later]
  end


  it "orders records by Domestic International" do
    JobApplication.delete_all
    results = JobApplication.order_by_domestic
    results.should == [earlier, middle, later]
  end

  xit "orders records by name" do
    JobApplication.delete_all
    results = JobApplication.order_by_name
    results.should == [earlier, middle, later]
  end

  it "orders records by ATAR" do
    JobApplication.delete_all
    results = JobApplication.order_by_atar
    results.should == [earlier, middle, later]
  end


  it "orders records by WAM" do
    JobApplication.delete_all
    results = JobApplication.order_by_wam
    results.should == [earlier, middle, later]
  end

  it "orders records by Degree" do
    JobApplication.delete_all
    results = JobApplication.order_by_degree
    results.should == [earlier, middle, later]
  end

end
