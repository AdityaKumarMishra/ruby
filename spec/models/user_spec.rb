require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:lost_tickets_user) { FactoryGirl.create :user, :lost_tickets }
  subject(:user) { FactoryGirl.build(:user, :student) }

  it 'has valid :user factory' do
    expect(user).to be_valid
  end

  # it 'should require a first_name' do
  #   FactoryGirl.build(:user, first_name: '').should_not be_valid
  # end

  # it 'should require a last_name' do
  #   FactoryGirl.build(:user, last_name: '').should_not be_valid
  # end

  it 'should require a email' do
    FactoryGirl.build(:user, email: '').should_not be_valid
  end

  it { expect(user).to have_and_belong_to_many :course_versions }

  it { expect(user).to have_one :address }
  it { expect(user).to have_many :tutor_answers }
  it { expect(user).to have_many :student_questions }

  # it { expect(user).to validate_presence_of :first_name }
  # it { expect(user).to validate_presence_of :last_name }
  it { expect(user).to validate_presence_of :email }

  # it { expect(user).to validate_length_of(:first_name).is_at_most(100) }
  # it { expect(user).to validate_length_of(:last_name).is_at_most(100) }
  # it { expect(user).to validate_length_of(:username).is_at_most(35) }
  # it { expect(user).to validate_length_of(:bio).is_at_most(500) }

  # it { expect(user).to validate_uniqueness_of(:username) }
  # it { expect(user).to validate_uniqueness_of(:slug) }
  it { expect(user).to validate_uniqueness_of(:email) }
  it { expect(user).to validate_numericality_of(:appointment_length).is_less_than(300) }
  it { should define_enum_for(:area) }

  describe '#destroy' do
    context 'with enrolment' do
      let!(:user) { FactoryGirl.create(:user) }

      it 'should destroy user' do
        expect { user.destroy }.to change(User, :count).by(-1)
      end
    end

    context 'with exercise and mcq attempt' do
      let!(:mcq_attempt) { FactoryGirl.create(:mcq_attempt) }
      let(:user) { mcq_attempt.exercise.user }

      it 'should destroy user' do
        expect { user.destroy }.to change(User, :count).by(-1)
      end
    end

    context 'with overseeing tags' do
      let(:tags) do
        [FactoryGirl.create(:tag),
         FactoryGirl.create(:tag)]
      end
      it 'should destroy user' do
        user.update(overseeing_tags: tags)
      end
    end

    context 'being answerer in ticket' do
      let!(:ticket) { FactoryGirl.create(:ticket) }
      let(:user) { FactoryGirl.create(:user) }

      it 'should destroy user' do
        ticket.update(answerer_id: user.id)
        expect { user.destroy }.to change(User, :count).by(-1)
      end
    end
  end

  describe '#specialty' do
    let!(:user) { FactoryGirl.create(:user, role: :tutor) }

    context 'when GC tutor' do
      let!(:tutor_profile) { FactoryGirl.create(:tutor_profile, tutor_id: user.id, issue_ticket: true, private_tutor: false) }

      it 'should give specialty as GC tutor' do
        expect(user.reload.specialty).to eq('GC Tutor')
      end
    end

    context 'when Private tutor' do
      let!(:tutor_profile) { FactoryGirl.create(:tutor_profile, tutor_id: user.id, private_tutor: true, issue_ticket: false) }

      it 'should give specialty as GC tutor' do
        expect(user.reload.specialty).to eq('Private Tutor')
      end
    end

    context 'when Essay marker' do
      let!(:staff_profile) { FactoryGirl.create(:staff_profile, staff_id: user.id) }

      it 'should give specialty as GC tutor' do
        expect(user.reload.specialty).to eq('Essay Marker')
      end
    end

    context 'when all' do
      let!(:tutor_profile) { FactoryGirl.create(:tutor_profile, tutor_id: user.id, issue_ticket: true) }
      let!(:tutor_profile) { FactoryGirl.create(:tutor_profile, tutor_id: user.id, private_tutor: true) }
      let!(:staff_profile) { FactoryGirl.create(:staff_profile, staff_id: user.id) }

      it 'should give specialty as all' do
        expect(user.reload.specialty).to eq('Essay Marker/Private Tutor/GC Tutor')
      end
    end

    context 'when none' do
      it 'should give NA' do
        expect(user.reload.specialty).to eq('NA')
      end
    end
  end

  describe 'scope with_account_status' do
    before do
      User.destroy_all
    end

    let!(:user1) { FactoryGirl.create(:user, role: :tutor, status: :activated) }
    let!(:user2) { FactoryGirl.create(:user, role: :tutor, status: :activated) }
    let!(:user3) { FactoryGirl.create(:user, role: :tutor, status: :deactivated) }

    context 'when querying activated' do
      it 'should return user 1 and 2' do
        expect(User.with_account_status(0).to_a).to eq([user1, user2])
      end
    end

    context 'when querying deactivated' do
      it 'should return user 3' do
        expect(User.with_account_status(1).to_a).to eq([user3])
      end
    end
  end

  describe 'scope by_state' do
    let!(:student1) { FactoryGirl.create(:user, role: :student) }
    let!(:enrolment1) { FactoryGirl.create(:enrolment) }
    let!(:order1) { FactoryGirl.create(:order, status: :paid, user: student1) }
    let!(:purchase_item1) { FactoryGirl.create(:purchase_item, purchasable: enrolment1, order: order1) }

    let!(:student2) { FactoryGirl.create(:user, role: :student) }
    let!(:enrolment2) { FactoryGirl.create(:enrolment) }
    let!(:order2) { FactoryGirl.create(:order, status: :paid, user: student2) }
    let!(:purchase_item2) { FactoryGirl.create(:purchase_item, purchasable: enrolment2, order: order2) }

    let!(:student3) { FactoryGirl.create(:user, role: :student) }
    let!(:enrolment3) { FactoryGirl.create(:enrolment) }
    let!(:order3) { FactoryGirl.create(:order, status: :paid, user: student3) }
    let!(:purchase_item3) { FactoryGirl.create(:purchase_item, purchasable: enrolment3, order: order3) }

    context 'with multiple cities selected' do
      before do
        enrolment1.course.update!(city: 0)
        enrolment2.course.update!(city: 1)
        enrolment3.course.update!(city: 2)
      end

      it 'returns the concerned students' do
        rel = User.by_state([0, 1])
        user_ids = rel.ids.sort

        expect(user_ids & [student1.id, student2.id, student3.id]).to eq([student1.id, student2.id])
      end
    end
  end

  describe 'scope by_product_version' do
    let!(:student1) { FactoryGirl.create(:user, role: :student) }
    let!(:enrolment1) { FactoryGirl.create(:enrolment) }
    let!(:order1) { FactoryGirl.create(:order, status: :paid, user: student1) }
    let!(:purchase_item1) { FactoryGirl.create(:purchase_item, purchasable: enrolment1, order: order1) }

    let!(:student2) { FactoryGirl.create(:user, role: :student) }
    let!(:enrolment2) { FactoryGirl.create(:enrolment) }
    let!(:order2) { FactoryGirl.create(:order, status: :paid, user: student2) }
    let!(:purchase_item2) { FactoryGirl.create(:purchase_item, purchasable: enrolment2, order: order2) }

    let!(:student3) { FactoryGirl.create(:user, role: :student) }
    let!(:enrolment3) { FactoryGirl.create(:enrolment) }
    let!(:order3) { FactoryGirl.create(:order, status: :paid, user: student3) }
    let!(:purchase_item3) { FactoryGirl.create(:purchase_item, purchasable: enrolment3, order: order3) }
    let(:pv_ids) { [enrolment1.course.product_version_id, enrolment2.course.product_version_id, enrolment2.course.product_version_id] }

    context 'with multiple product versions selected' do
      it 'returns the concerned students' do
        rel = User.by_product_version(pv_ids[0..1])
        user_ids = rel.ids.sort

        expect(user_ids & [student1.id, student2.id, student3.id]).to eq([student1.id, student2.id])
      end
    end

    context 'with multiple product versions and multiple cities selected' do
      before do
        enrolment1.course.update!(city: 0)
        enrolment2.course.update!(city: 1)
        enrolment3.course.update!(city: 2)
      end

      it 'returns the concerned students' do
        rel = User.by_product_version(pv_ids[0..1]).by_state([1])
        user_ids = rel.ids.sort

        expect(user_ids & [student1.id, student2.id, student3.id]).to eq([student2.id])
      end
    end
  end

  describe 'scope by_master_feature' do
    let!(:student1) { FactoryGirl.create(:user, role: :student) }
    let!(:enrolment1) { FactoryGirl.create(:enrolment) }
    let!(:order1) { FactoryGirl.create(:order, status: :paid, user: student1) }
    let!(:purchase_item1) { FactoryGirl.create(:purchase_item, purchasable: enrolment1, order: order1) }
    let!(:master_feature1) { FactoryGirl.create(:master_feature) }
    let!(:pvfp1) { FactoryGirl.create(:product_version_feature_price, master_feature_id: master_feature1.id, product_version_id: enrolment1.course.product_version_id) }
    let!(:feature_log1) { FactoryGirl.create(:feature_log, product_version_feature_price_id: pvfp1.id, enrolment_id: enrolment1.id, acquired: Time.zone.now.to_s) }

    let!(:student2) { FactoryGirl.create(:user, role: :student) }
    let!(:enrolment2) { FactoryGirl.create(:enrolment) }
    let!(:order2) { FactoryGirl.create(:order, status: :paid, user: student2) }
    let!(:purchase_item2) { FactoryGirl.create(:purchase_item, purchasable: enrolment2, order: order2) }
    let!(:master_feature2) { FactoryGirl.create(:master_feature) }
    let!(:pvfp2) { FactoryGirl.create(:product_version_feature_price, master_feature_id: master_feature2.id, product_version_id: enrolment2.course.product_version_id) }
    let!(:feature_log2) { FactoryGirl.create(:feature_log, product_version_feature_price_id: pvfp2.id, enrolment_id: enrolment2.id, acquired: Time.zone.now.to_s) }

    let!(:student3) { FactoryGirl.create(:user, role: :student) }
    let!(:enrolment3) { FactoryGirl.create(:enrolment) }
    let!(:order3) { FactoryGirl.create(:order, status: :paid, user: student3) }
    let!(:purchase_item3) { FactoryGirl.create(:purchase_item, purchasable: enrolment3, order: order3) }
    let(:pv_ids) { [enrolment1.course.product_version_id, enrolment2.course.product_version_id, enrolment2.course.product_version_id] }
    let!(:master_feature3) { FactoryGirl.create(:master_feature) }
    let!(:pvfp3) { FactoryGirl.create(:product_version_feature_price, master_feature_id: master_feature3.id, product_version_id: enrolment3.course.product_version_id) }
    let!(:feature_log3) { FactoryGirl.create(:feature_log, product_version_feature_price_id: pvfp3.id, enrolment_id: enrolment3.id, acquired: Time.zone.now.to_s) }
    let(:mf_ids) { [master_feature1.id, master_feature2.id, master_feature3.id] }

    context 'with multiple master features selected' do
      it 'returns the concerned students' do
        rel = User.by_master_feature(mf_ids[0..1])
        user_ids = rel.ids.sort

        expect(user_ids & [student1.id, student2.id, student3.id]).to eq([student1.id, student2.id])
      end
    end

    context 'with multiple cities and multiple product versions and multiple master features' do
      before do
        allow(User).to receive(:filter_params)
        enrolment1.course.update!(city: 0)
        enrolment2.course.update!(city: 1)
        enrolment3.course.update!(city: 2)
      end

      it 'returns the concerned students' do
        rel = User.by_master_feature(mf_ids[0..1]).by_product_version([pv_ids[0]]).by_state([0])
        user_ids = rel.ids.sort

        expect(user_ids & [student1.id, student2.id, student3.id]).to eq([student1.id])
      end

      it 'returns the concerned students' do
        rel = User.by_master_feature(mf_ids[0..1]).by_product_version([pv_ids[0]]).by_state([1])
        user_ids = rel.ids.sort

        expect(user_ids).to be_blank
      end
    end
  end

  describe 'scope with_specialty' do
    before do
      User.destroy_all
    end

    let!(:user1) { FactoryGirl.create(:user, role: :tutor) }
    let!(:tutor_profile1) { FactoryGirl.create(:tutor_profile, tutor_id: user1.id, issue_ticket: true, private_tutor: false) }

    let!(:user2) { FactoryGirl.create(:user, role: :tutor) }
    let!(:tutor_profile2) { FactoryGirl.create(:tutor_profile, tutor_id: user2.id, issue_ticket: false, private_tutor: true) }

    let!(:user3) { FactoryGirl.create(:user, role: :tutor) }
    let!(:staff_profile) { FactoryGirl.create(:staff_profile, staff_id: user3.id) }

    it 'should query the right users' do
      expect(User.with_specialty('Essay Marker').to_a).to eq([user3])
      expect(User.with_specialty('Private Tutor').to_a).to eq([user2])
      expect(User.with_specialty('GC Tutor').to_a).to eq([user1])
    end
  end

  describe '#moderator?' do
    describe 'role Student' do
      let(:user) { FactoryGirl.build(:user, :student) }
      it 'should return false for student' do
        expect(user.moderator?).to eq false
      end
    end
    describe 'role Tutor' do
      let(:user) { FactoryGirl.build(:user, :tutor) }
      it 'should return false for student' do
        expect(user.moderator?).to eq false
      end
    end
    describe 'role Admin' do
      let(:user) { FactoryGirl.build(:user, :admin) }
      it 'should return false for student' do
        expect(user.moderator?).to eq true
      end
    end
    describe '#answered_mcqs' do
      let!(:mcq) { FactoryGirl.build(:mcq) }
      let!(:mcq_answer) { FactoryGirl.build(:mcq_answer, mcq: mcq) }
      let!(:student_mcq_answers) { FactoryGirl.build_list(:mcq_student_answer, 2, mcq_answer: mcq_answer) }
    end
  end

  describe '#update' do
    context 'with overseeing tags' do
      let(:tags) do
        [FactoryGirl.create(:tag),
         FactoryGirl.create(:tag)]
      end
      it 'updates overseeing tags' do
        user.update(overseeing_tags: tags)
        expect(user.overseeing_tags).to eq(tags)
      end
    end
  end

  describe '#options_for_non_student_select' do
    let(:non_student) { FactoryGirl.create(:user, role: 4) }
    let(:non_students) { User.where.not(role: 0).map { |e| [e.full_name, e.id] } }
    let(:results) { User.options_for_non_student_select }
    it 'should return non-student users' do
      expect(results).to match_array(non_students)
    end
  end

  # describe 'purchased_addons' do
  #   context 'with purchased addons' do
  #     let!(:user) { FactoryGirl.create(:user) }
  #     let!(:order) { FactoryGirl.create(:order, status: :paid, user: user) }
  #     let!(:enrolment) { FactoryGirl.create(:enrolment, user: user) }
  #     let!(:feature_enrolment) { FactoryGirl.create(:feature_enrolment, enrolment: enrolment, active: true) }
  #     let!(:featurette) { FactoryGirl.create(:featurette, feature_enrolment: feature_enrolment) }
  #     let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: user, order: order, purchasable: featurette) }
  #     let!(:order_unpaid) { FactoryGirl.create(:order, status: :ongoing, user: user) }
  #     let!(:feature_enrolment_unpaid) { FactoryGirl.create(:feature_enrolment, enrolment: enrolment, active: false) }
  #     let!(:featurette_unpaid) { FactoryGirl.create(:featurette, feature_enrolment: feature_enrolment_unpaid) }
  #     let!(:unpaid_purchase_item) { FactoryGirl.create(:purchase_item, user: user, order: order_unpaid, purchasable: featurette_unpaid) }
  #     it 'should only return the paid featurette' do
  #       expect(user.purchased_addons).to eq [feature_enrolment]
  #     end
  #   end
  # end

  describe '#options_for_role' do
    it 'returns all roles of user' do
      role = role
      allow(role).to receive(:user).and_return('student', 'tutor', 'manager', 'admin', 'superadmin')
      expect(role.user).to eq('student')
      expect(role.user).to eq('tutor')
      expect(role.user).to eq('manager')
      expect(role.user).to eq('admin')
      expect(role.user).to eq('superadmin')
    end
  end

  describe '#with_name' do
    let(:user) { FactoryGirl.create(:user, first_name: 'Test') }
    let(:students) { User.where(first_name: 'Test') }
    let(:results) { User.with_name(user) }
    it 'should return users' do
      expect(results).to match_array(students)
    end
  end

  describe '#accessible_features' do
    let!(:user) { FactoryGirl.create(:user, role: 0) }
    context '#accessible_features' do
      let!(:productVer) { FactoryGirl.create(:product_version) }
      let!(:course1) { FactoryGirl.create(:course, expiry_date: Time.zone.today + 5.days, product_version_id: productVer.id) }
      let!(:order1) { FactoryGirl.create(:order, status: :paid, user: user) }
      let!(:enrolment1) { FactoryGirl.create(:enrolment, course_id: course1.id) }
      let!(:master_feature) { FactoryGirl.create(:master_feature, name: 'Diagnostics Assessment', title: 'Diagnostics Assessment') }
      let!(:pvfp) do
        FactoryGirl.create(:product_version_feature_price,
                           master_feature: master_feature,
                           product_version: productVer, is_default: true
                          )
      end
      let!(:feature_log) do
        FactoryGirl.create(:feature_log, product_version_feature_price: pvfp,
                                         acquired: Time.zone.now, enrolment: enrolment1
                          )
      end
      let!(:paid_purchase_item1) { FactoryGirl.create(:purchase_item, user: user, order: order1, purchasable: enrolment1) }

      it 'should only return the features of student those course are not expired' do
        user.update_attribute(:active_course_id, course1.id)
        expect(user.accessible_features).to eq [master_feature]
      end
    end
    context '#accessible_features' do
      let!(:course2) { FactoryGirl.create(:course, expiry_date: Time.zone.today - 5.days) }
      let!(:enrolment2) { FactoryGirl.create(:enrolment, course_id: course2.id) }
      let!(:productVer) { FactoryGirl.create(:product_version) }
      let!(:master_feature) { FactoryGirl.create(:master_feature, name: 'Diagnostics Assessment', title: 'Diagnostics Assessment') }
      let!(:pvfp) do
        FactoryGirl.create(:product_version_feature_price,
                           master_feature: master_feature,
                           product_version: productVer, is_default: true
                          )
      end
      let!(:feature_log) do
        FactoryGirl.create(:feature_log, product_version_feature_price: pvfp,
                                         acquired: Time.zone.now, enrolment: enrolment2
                          )
      end

      it 'should not return the features of student those course are expired' do
        expect(user.accessible_features).to eq []
      end
    end
  end

  describe '#course_enroled?' do
    let!(:student) { FactoryGirl.create(:user) }
    let!(:order) { FactoryGirl.create(:order, status: :paid, user: student) }
    let!(:enrolment) { FactoryGirl.create(:enrolment) }
    let!(:productVer) { FactoryGirl.create(:product_version) }
    let!(:master_feature) { FactoryGirl.create(:master_feature, name: 'GamsatExamFeature', title: 'Exams') }
    let!(:pvfp) do
      FactoryGirl.create(:product_version_feature_price,
                         master_feature: master_feature,
                         product_version: productVer, is_default: true
                        )
    end
    let!(:feature_log) do
      FactoryGirl.create(:feature_log, product_version_feature_price: pvfp,
                                       acquired: Time.zone.now, enrolment: enrolment
                        )
    end
    let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: student, order: order, purchasable: enrolment) }
    let!(:course) { enrolment.course }

    it 'should return true' do
      expect(student.course_enroled?(course.id)).to eq true
    end
  end

  describe '#has_only_free_trial?' do
    let!(:student) { FactoryGirl.create(:user, :student) }
    let!(:order) { FactoryGirl.create(:order, status: :paid, user: student) }
    let!(:enrolment) { FactoryGirl.create :enrolment, trial: true, trial_expiry: Time.zone.now + 1.day }

    let!(:productVer) { FactoryGirl.create(:product_version) }
    let!(:master_feature) { FactoryGirl.create(:master_feature, name: 'GamsatExamFeature', title: 'Exams') }
    let!(:pvfp) do
      FactoryGirl.create(:product_version_feature_price,
                         master_feature: master_feature,
                         product_version: productVer, is_default: true
                        )
    end
    let!(:feature_log) do
      FactoryGirl.create(:feature_log, product_version_feature_price: pvfp,
                                       acquired: Time.zone.now, enrolment: enrolment
                        )
    end
    let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: student, order: order, purchasable: enrolment) }

    it 'should return true when having only one enrolment and that enrolment is a trial' do
      expect(student.has_only_free_trial?).to eq true
    end
  end

  describe '#trial_enrolment' do
    let!(:student) { FactoryGirl.create(:user, :student) }
    let!(:order) { FactoryGirl.create(:order, status: :paid, user: student) }
    let!(:enrolment) { FactoryGirl.create :enrolment, trial: true, trial_expiry: Time.zone.now + 1.day }

    let!(:productVer) { FactoryGirl.create(:product_version) }
    let!(:master_feature) { FactoryGirl.create(:master_feature, name: 'GamsatExamFeature', title: 'Exams') }
    let!(:pvfp) do
      FactoryGirl.create(:product_version_feature_price,
                         master_feature: master_feature,
                         product_version: productVer, is_default: true
                        )
    end
    let!(:feature_log) do
      FactoryGirl.create(:feature_log, product_version_feature_price: pvfp,
                                       acquired: Time.zone.now, enrolment: enrolment
                        )
    end
    let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: student, order: order, purchasable: enrolment) }

    it 'should return trial_enrolment' do
      expect(student.trial_enrolment).to eq enrolment
    end
  end

  describe '#trial_enrolment' do
    let!(:student) { FactoryGirl.create(:user, :student) }
    let!(:order) { FactoryGirl.create(:order, status: :paid, user: student) }
    let!(:enrolment) { FactoryGirl.create :enrolment, trial: true, trial_expiry: Time.zone.now + 1.day }

    let!(:productVer) { FactoryGirl.create(:product_version) }
    let!(:master_feature) { FactoryGirl.create(:master_feature, name: 'GamsatExamFeature', title: 'Exams') }
    let!(:pvfp) do
      FactoryGirl.create(:product_version_feature_price,
                         master_feature: master_feature,
                         product_version: productVer, is_default: true
                        )
    end
    let!(:feature_log) do
      FactoryGirl.create(:feature_log, product_version_feature_price: pvfp,
                                       acquired: Time.zone.now, enrolment: enrolment
                        )
    end
    let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: student, order: order, purchasable: enrolment) }
    let(:course) { enrolment.course }
    it 'should return course of trial_enrolment' do
      expect(student.trial_course).to eq course
    end
  end

  describe '#paid_enrolments' do
    let!(:student) { FactoryGirl.create(:user, :student) }
    let!(:order) { FactoryGirl.create(:order, status: :paid, user: student) }
    let!(:enrolment) { FactoryGirl.create :enrolment, trial: true, trial_expiry: Time.zone.now + 1.day }

    let!(:productVer) { FactoryGirl.create(:product_version) }
    let!(:master_feature) { FactoryGirl.create(:master_feature, name: 'GamsatExamFeature', title: 'Exams') }
    let!(:pvfp) do
      FactoryGirl.create(:product_version_feature_price,
                         master_feature: master_feature,
                         product_version: productVer, is_default: true
                        )
    end

    let!(:feature_log) do
      FactoryGirl.create(:feature_log, product_version_feature_price: pvfp,
                                       acquired: Time.zone.now, enrolment: enrolment
                        )
    end
    let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: student, order: order, purchasable: enrolment) }
    it 'should return paid enrolments of a user' do
      expect(enrolment).to eq enrolment
    end
  end

  describe '#events_dates' do
    context "events_dates" do
      let!(:student) { FactoryGirl.create(:user) }
      let!(:order) { FactoryGirl.create(:order, status: :paid, user: student) }
      let!(:enrolment) { FactoryGirl.create(:enrolment) }
      let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: student, order: order, purchasable: enrolment) }
      let!(:course) { enrolment.course }
      let!(:essay) {FactoryGirl.create(:essay)}
      let!(:essay_response) {FactoryGirl.create(:essay_response, essay_id: essay.id, user: student)}
      it 'should return important dates to be shown on calender' do
        if course.product_version.type == 'GamsatReady'
          events_dates = ["2017-03-25", "2017-09-13"]
        elsif course.product_version.type == 'UmatReady'
          events_dates = ["2017-07-26"]
        end
        events_dates << course.lessons.first.date.strftime("%Y-%m-%d")
        events_dates << course.expiry_date.strftime("%Y-%m-%d")
        events_dates << essay_response.expiry_date.strftime("%Y-%m-%d")
        expect(User.events_dates(student, course)).to eq(events_dates)
      end
    end
  end

  describe '#has_clarity_feature' do
    let!(:productVer) { FactoryGirl.create(:product_version) }
    let!(:student) { FactoryGirl.create(:user, :student) }
    let!(:course) { FactoryGirl.create(:course, product_version_id: productVer.id) }
    let!(:enrolment) { FactoryGirl.create(:enrolment, course_id: course.id) }
    let!(:order) { FactoryGirl.create(:order, status: :paid, user: student) }

    let!(:master_feature1) { FactoryGirl.create(:master_feature, name: 'GamsatExamFeature', title: 'Exams') }
    let!(:master_feature2) { FactoryGirl.create(:master_feature, name: 'GamsatGetClarityFeature', title: 'Get Clarity') }

    let!(:pvfp1) do
      FactoryGirl.create(:product_version_feature_price,
                         master_feature: master_feature1,
                         product_version: productVer, is_default: true
                        )
    end

    let!(:pvfp2) do
      FactoryGirl.create(:product_version_feature_price,
                         master_feature: master_feature2,
                         product_version: productVer, is_default: true
                        )
    end

    let!(:feature_log1) do
      FactoryGirl.create(:feature_log, product_version_feature_price: pvfp1,
                                       acquired: Time.zone.now, enrolment: enrolment
                        )
    end

    let!(:feature_log2) do
      FactoryGirl.create(:feature_log, product_version_feature_price: pvfp2,
                                       acquired: Time.zone.now, enrolment: enrolment
                        )
    end

    let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: student, order: order, purchasable: enrolment) }
    it 'should return get clarity feature' do
      student.update_attribute(:active_course_id, course.id)
      expect(student.has_clarity_feature).to eq([master_feature2])
    end
  end

  describe '#active_courses' do
    let!(:student) { FactoryGirl.create(:user, :student) }
    let!(:course) { FactoryGirl.create(:course) }
    let!(:enrolment) { FactoryGirl.create(:enrolment, course_id: course.id) }
    let!(:order) { FactoryGirl.create(:order, status: :paid, user: student) }
    let!(:productVer) { FactoryGirl.create(:product_version) }
    let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: student, order: order, purchasable: enrolment) }
    it 'should return active courses of user' do
      expect(student.active_courses).to eq([course])
    end
  end

  describe '#validate_user_address' do
    context 'if user have address' do
      let!(:user) { FactoryGirl.create(:user) }
      it 'should return nil' do
        expect(user.validate_user_address).to eq(nil)
      end
    end

    context 'if user do not have address' do
      let!(:user) { FactoryGirl.create(:user, address: nil) }
      it 'should build user address' do
        expect(user.validate_user_address).to be_a_new(Address)
      end
    end
  end

  describe '#current_product_verion_feature_price' do
    let!(:productVer) { FactoryGirl.create(:product_version) }
    let!(:student) { FactoryGirl.create(:user, :student) }
    let!(:course) { FactoryGirl.create(:course, product_version_id: productVer.id) }
    let!(:enrolment) { FactoryGirl.create(:enrolment, course_id: course.id) }
    let!(:order) { FactoryGirl.create(:order, status: :paid, user: student) }

    let!(:master_feature1) { FactoryGirl.create(:master_feature, name: 'GamsatExamFeature', title: 'Exams') }
    let!(:master_feature2) { FactoryGirl.create(:master_feature, name: 'GamsatGetClarityFeature', title: 'Get Clarity') }

    let!(:pvfp1) do
      FactoryGirl.create(:product_version_feature_price,
                         master_feature: master_feature1,
                         product_version: productVer, is_default: true
                        )
    end

    let!(:pvfp2) do
      FactoryGirl.create(:product_version_feature_price,
                         master_feature: master_feature2,
                         product_version: productVer, is_default: true
                        )
    end

    let!(:feature_log1) do
      FactoryGirl.create(:feature_log, product_version_feature_price: pvfp1,
                                       acquired: Time.zone.now, enrolment: enrolment
                        )
    end

    let!(:feature_log2) do
      FactoryGirl.create(:feature_log, product_version_feature_price: pvfp2,
                                       acquired: Time.zone.now, enrolment: enrolment
                        )
    end

    let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: student, order: order, purchasable: enrolment) }

    it 'should return all active product version feature prices' do
      student.update_attribute(:active_course_id, course.id)
      expect(student.active_product_version_feature_prices).to match_array([pvfp1, pvfp2])
    end

    it 'should return product version feature prices for GamsatExamFeature' do
      student.update_attribute(:active_course_id, course.id)
      expect(student.current_product_verion_feature_price('ExamFeature')).to eq(pvfp1)
    end
  end

   describe '#current_feature_tags' do
    let!(:productVer) { FactoryGirl.create(:product_version) }
    let!(:student) { FactoryGirl.create(:user, :student) }
    let!(:course) { FactoryGirl.create(:course, product_version_id: productVer.id) }
    let!(:enrolment) { FactoryGirl.create(:enrolment, course_id: course.id) }
    let!(:order) { FactoryGirl.create(:order, status: :paid, user: student) }

    let!(:master_feature1) { FactoryGirl.create(:master_feature, name: 'GamsatExamFeature', title: 'Exams') }
    let!(:master_feature2) { FactoryGirl.create(:master_feature, name: 'GamsatGetClarityFeature', title: 'Get Clarity') }

    let!(:pvfp1) do
      FactoryGirl.create(:product_version_feature_price,
                         master_feature: master_feature1,
                         product_version: productVer, is_default: true
                        )
    end

    let!(:pvfp2) do
      FactoryGirl.create(:product_version_feature_price,
                         master_feature: master_feature2,
                         product_version: productVer, is_default: true
                        )
    end

    let!(:feature_log1) do
      FactoryGirl.create(:feature_log, product_version_feature_price: pvfp1,
                                       acquired: Time.zone.now, enrolment: enrolment
                        )
    end

    let!(:feature_log2) do
      FactoryGirl.create(:feature_log, product_version_feature_price: pvfp2,
                                       acquired: Time.zone.now, enrolment: enrolment
                        )
    end

    let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: student, order: order, purchasable: enrolment) }

    it 'should return tags for GamsatExamFeature' do
      student.update_attribute(:active_course_id, course.id)
      expect(student.current_feature_tags('ExamFeature')).to eq(pvfp1.tags)
    end
  end
end
