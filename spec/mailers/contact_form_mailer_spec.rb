require "rails_helper"

RSpec.describe ContactFormMailer, type: :mailer do
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    @contact_form = Factory.create(:contact_form)
    ContactFormMailer.user_inqury(@contact_form).deliver
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end
  pending 'should send an email' do
     ActionMailer::Base.deliveries.count.should == 1
  end

  pending 'renders the receiver email' do
     ActionMailer::Base.deliveries.first.to.should == @contact_form.email
  end

  pending 'should set the subject to the correct subject' do
     ActionMailer::Base.deliveries.first.subject.should == 'Inqury from conntact form'
  end
end
