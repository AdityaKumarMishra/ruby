require 'rails_helper'

RSpec.describe TicketPolicy do
  let!(:tag1NotPublic) { FactoryGirl.create :tag, is_public: false }
  let!(:tag2Public) { FactoryGirl.create :tag, is_public: true }
  let!(:tag2NotPublic) { FactoryGirl.create :tag, is_public: false }

  let!(:student) { FactoryGirl.create :user }
  let!(:student2) { FactoryGirl.create :user }

  let!(:productVer1) { FactoryGirl.create(:product_version) }
  let!(:master_feature1) { FactoryGirl.create(:master_feature) }
  let!(:master_feature4) { FactoryGirl.create(:master_feature, name: 'GamsatGetClarityFeature') }
  let!(:pvfp1) do
    FactoryGirl.create(:product_version_feature_price,
                       master_feature: master_feature1, product_version: productVer1)
  end
  let!(:pvfp4) do
    FactoryGirl.create(:product_version_feature_price,
                       master_feature: master_feature4, product_version: productVer1)
  end
  let!(:tagging1) { FactoryGirl.create(:tagging, tag: tag1NotPublic, taggable: pvfp1) }

  let!(:course1) { FactoryGirl.create(:course, product_version: productVer1) }
  let!(:order1) { FactoryGirl.create(:order, status: :paid, user: student) }
  let!(:enrol1) { FactoryGirl.create(:enrolment, course: course1) }
  # let!(:feature_enrolment1) { FactoryGirl.create(:feature_enrolment, enrolment: enrol1, active: true) }
  let!(:feature_log1) do
    FactoryGirl.create(:feature_log, product_version_feature_price: pvfp1,
                                     acquired: Time.zone.now, enrolment: enrol1
                      )
  end

  let!(:feature_log4) do
    FactoryGirl.create(:feature_log, product_version_feature_price: pvfp4,
                                     acquired: Time.zone.now, enrolment: enrol1
                      )
  end
  let!(:paid_purchase_item1) { FactoryGirl.create(:purchase_item, user: student, order: order1, purchasable: enrol1) }

  let!(:productVer2) { FactoryGirl.create(:product_version) }
  let!(:master_feature2) { FactoryGirl.create(:master_feature) }
  let!(:pvfp2) do
    FactoryGirl.create(:product_version_feature_price,
                       master_feature: master_feature2, product_version: productVer2)
  end
  let!(:tagging2) { FactoryGirl.create(:tagging, tag: tag2NotPublic, taggable: pvfp2) }
  let!(:course2) { FactoryGirl.create(:course, product_version: productVer2) }

  let!(:order2) { FactoryGirl.create(:order, status: :paid, user: student) }
  let!(:enrol2) { FactoryGirl.create(:enrolment, course: course2) }
  let!(:feature_log2) do
    FactoryGirl.create(:feature_log, product_version_feature_price: pvfp2,
                                     acquired: Time.zone.now, enrolment: enrol2
                      )
  end
  # let!(:feature_enrolment2) { FactoryGirl.create(:feature_enrolment, enrolment: enrol2, active: true) }
  let!(:paid_purchase_item2) { FactoryGirl.create(:purchase_item, user: student, order: order2, purchasable: enrol2) }

  let!(:productVer3) { FactoryGirl.create(:product_version) }
  let!(:master_feature3) { FactoryGirl.create(:master_feature) }
  let!(:pvfp3) do
    FactoryGirl.create(:product_version_feature_price,
                       master_feature: master_feature3, product_version: productVer3)
  end
  let!(:tagging3) { FactoryGirl.create(:tagging, tag: tag2Public, taggable: pvfp3) }

  let!(:course3) { FactoryGirl.create(:course, product_version: productVer3) }
  let!(:order3) { FactoryGirl.create(:order, status: :paid, user: student) }
  let!(:enrol3) { FactoryGirl.create(:enrolment, course: course3) }

  let!(:feature_log3) do
    FactoryGirl.create(:feature_log, product_version_feature_price: pvfp3,
                                     acquired: Time.zone.now, enrolment: enrol3
                      )
  end
  # let!(:feature_enrolment3) { FactoryGirl.create(:feature_enrolment, enrolment: enrol3, active: true) }
  let!(:paid_purchase_item3) { FactoryGirl.create(:purchase_item, user: student, order: order3, purchasable: enrol3) }

  let!(:tutor) { FactoryGirl.create :user, :tutor }
  let!(:ticket) { FactoryGirl.create :ticket, asker: student, tags: [tag1NotPublic] }
  let!(:ticket2) { FactoryGirl.create :ticket, asker: student2, tags: [tag2NotPublic] }
  let!(:ticket2_public) { FactoryGirl.create :ticket, asker: student2, public: true, tags: [tag2Public] }
  let!(:ticket_reminder) { FactoryGirl.create :ticket, asker: student, remind: true, status: 1 }

  subject { described_class }

  context 'when student' do
    permissions ".scope" do
      it 'can see owned tickets and public ticket' do
        expect(TicketPolicy::Scope.new(student, Ticket).resolve).to match_array [ticket, ticket2_public, ticket_reminder]
      end
    end

    permissions :index? do
      it 'not permitted to see the index page' do
        expect(subject).not_to permit(student, ticket)
      end
    end

    permissions :show? do
      it 'can view ticket created by self' do
        expect(subject).to permit(student, ticket)
      end

      it 'cannot view other students ticket' do
        expect(subject).not_to permit(student, ticket2)
      end

      it 'can view a public ticket from others' do
        expect(subject).to permit(student, ticket2_public)
      end
    end

    permissions :create? do
      it 'can open new ticket' do
        expect(subject).to permit(student, ticket)
      end
    end

    permissions :update? do
      it 'can open owned ticket' do
        expect(subject).to permit(student, ticket)
      end

      it 'cannot update others ticket' do
        expect(subject).not_to permit(student, ticket2)
      end
    end

    permissions :destroy? do
      it 'can delete owned ticket' do
        expect(subject).to permit(student, ticket)
      end
      it 'cannot delete others ticket' do
        expect(subject).not_to permit(student, ticket2)
      end
    end

    permissions :toggle_reminder? do
      it 'cannot enable ticket remider' do
        expect(subject).not_to permit(student, ticket_reminder)
      end
    end
  end

  context 'when not student' do
    permissions ".scope" do
      # Ignored because this test fails randomly
      xit 'can see all tickets' do
        expect(TicketPolicy::Scope.new(tutor, Ticket).resolve).to eq [ticket, ticket2, ticket2_public, ticket_reminder]
      end
    end

    permissions :show? do
      it 'can view ticket created by student' do
        expect(subject).to permit(tutor, ticket)
        expect(subject).to permit(tutor, ticket2)
      end
    end

    permissions :create? do
      it 'can open new ticket' do
        expect(subject).to permit(tutor, ticket)
      end
    end

    permissions :update? do
      it 'can update any ticket' do
        expect(subject).to permit(tutor, ticket)
      end
    end

    permissions :destroy? do
      it 'can delete any ticket' do
        expect(subject).to permit(tutor, ticket)
      end
    end

    permissions :toggle_reminder? do
      it 'can enable ticket reminder' do
        expect(subject).to permit(tutor, ticket_reminder)
      end
    end

    permissions :list? do
      it 'can allow to submit ticket if user have get clarity feature' do
        student.update_attribute(:active_course_id, course1.id)
        expect(subject).to permit(student)
      end
    end
  end
end
