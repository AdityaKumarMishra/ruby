require 'rails_helper'

RSpec.describe MassEmailJob, type: :job do
  let!(:user) {FactoryGirl.create(:user)}
  it "matches with enqueued job" do
    ActiveJob::Base.queue_adapter = :test
    MassEmailJob.perform_later([user.id], 'Test Subject', 'Test content')
  end
end
