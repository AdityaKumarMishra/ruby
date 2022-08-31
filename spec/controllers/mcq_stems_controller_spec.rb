require 'rails_helper'

RSpec.describe McqStemsController, type: :controller do
  login_superadmin
  let!(:tag) { FactoryGirl.create :tag }
  let(:reviewer) {FactoryGirl.create :user, :tutor}
  let(:creator) {FactoryGirl.create :user, :tutor}
  let(:valid_attributes) do
    FactoryGirl.attributes_for(:mcq_stem, tag_ids: [tag.id], reviewer_id: reviewer.id, author_id: creator.id)
  end

  let(:invalid_attributes) do
    FactoryGirl.attributes_for(:mcq_stem, title: '')
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # McqStemsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  # Tutor Authorization
  let!(:tutor) { FactoryGirl.create(:user, :tutor) }

  before { sign_in tutor }

  describe 'GET #index' do
    it 'assigns all mcq_stems as @mcq_stems' do
      mcq_stem = McqStem.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:mcq_stems)).to eq([mcq_stem])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested mcq_stem as @mcq_stem' do
      mcq_stem = McqStem.create! valid_attributes
      get :show, { id: mcq_stem.to_param }, valid_session
      expect(assigns(:mcq_stem)).to eq(mcq_stem)
    end
  end

  describe 'GET #new' do
    it 'assigns a new mcq_stem as @mcq_stem' do
      get :new, {}, valid_session
      expect(assigns(:difficulties).to_h).to eq({""=>"",:easy=>1, :medium=>50, :hard=>100})
      expect(assigns(:mcq_stem)).to be_a_new(McqStem)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested mcq_stem as @mcq_stem' do
      mcq_stem = McqStem.create! valid_attributes
      get :edit, { id: mcq_stem.to_param }, valid_session
      expect(assigns(:difficulties).to_h).to eq({""=>"",:easy=>1, :medium=>50, :hard=>100})
      expect(assigns(:mcq_stem)).to eq(mcq_stem)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new McqStem' do
        expect do
          post :create, { mcq_stem: valid_attributes }, valid_session
        end.to change(McqStem, :count).by(1).and change(Tagging, :count).by(1)
      end

      it 'assigns a newly created mcq_stem as @mcq_stem' do
        post :create, { mcq_stem: valid_attributes }, valid_session
        expect(assigns(:mcq_stem)).to be_a(McqStem)
        expect(assigns(:mcq_stem)).to be_persisted
      end

      it 'redirects to the mcq creation page' do
        post :create, { mcq_stem: valid_attributes }, valid_session
        mcq_stem = assigns(:mcq_stem)
        expect(response).to redirect_to(mcq_stem_path(mcq_stem))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved mcq_stem as @mcq_stem' do
        post :create, { mcq_stem: invalid_attributes }, valid_session
        expect(assigns(:mcq_stem)).to be_a_new(McqStem)
      end

      it "re-renders the 'new' template" do
        post :create, { mcq_stem: invalid_attributes }, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        FactoryGirl.attributes_for(:mcq_stem, title: 'updated title')
      end

      it 'updates the requested mcq_stem' do
        mcq_stem = McqStem.create! valid_attributes
        put :update, { id: mcq_stem.to_param, mcq_stem: new_attributes }, valid_session
        mcq_stem.reload
        expect(assigns(:difficulties).to_h).to eq({''=>'',:easy=>1, :medium=>50, :hard=>100})
        expect(mcq_stem.title).to eq('updated title')
      end

      it 'assigns the requested mcq_stem as @mcq_stem' do
        mcq_stem = McqStem.create! valid_attributes
        put :update, { id: mcq_stem.to_param, mcq_stem: valid_attributes }, valid_session
        expect(assigns(:mcq_stem)).to eq(mcq_stem)
      end

      it 'redirects to the mcq_stem' do
        mcq_stem = McqStem.create! valid_attributes
        put :update, { id: mcq_stem.to_param, mcq_stem: valid_attributes }, valid_session
        expect(response).to redirect_to(mcq_stem)
      end
    end

    context 'with invalid params' do
      it 'assigns the mcq_stem as @mcq_stem' do
        mcq_stem = McqStem.create! valid_attributes
        put :update, { id: mcq_stem.to_param, mcq_stem: invalid_attributes }, valid_session
        expect(assigns(:mcq_stem)).to eq(mcq_stem)
      end

      it "re-renders the 'edit' template" do
        mcq_stem = McqStem.create! valid_attributes
        put :update, { id: mcq_stem.to_param, mcq_stem: invalid_attributes }, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested mcq_stem' do
      mcq_stem = McqStem.create! valid_attributes
      expect do
        delete :destroy, { id: mcq_stem.to_param }, valid_session
      end.to change(McqStem, :count).by(-1).and change(Tagging, :count).by(-1)
    end

    it 'redirects to the mcq_stems list' do
      mcq_stem = McqStem.create! valid_attributes
      delete :destroy, { id: mcq_stem.to_param }, valid_session
      expect(response).to redirect_to(mcq_stems_url)
    end
  end

  describe "POST sort_mcqs_order mcqs" do
    context "with no submission" do
      before do
        @mcq_stem = FactoryGirl.create(:mcq_stem)
        @mcq1 = FactoryGirl.create(:mcq)
        @mcq2 = FactoryGirl.create(:mcq)
        @mcq3 = FactoryGirl.create(:mcq)
        @mcq_stem.mcqs << [@mcq1, @mcq2, @mcq3]
        @mcq_stem.save
        @cj1 = @mcq_stem.mcqs.find(@mcq1.id)
        @cj2 = @mcq_stem.mcqs.find(@mcq2.id)
        @cj3 = @mcq_stem.mcqs.find(@mcq3.id)
        @cj1.position = 1
        @cj2.position = 2
        @cj3.position = 3
        @cj1.save
        @cj2.save
        @cj3.save
        @attr = [@mcq3.id, @mcq2.id, @mcq1.id]
      end
      it "order mcqs according to position" do
        xhr :post, :sort_mcqs_order, { :id => @mcq_stem.id, :mcq => @attr }
        @mcq_stem.reload
        @mcq_stem.mcqs.find(@mcq1.id).position.should == 3
      end
    end
  end

  describe "GET change_examinable" do
    before(:each) do
      request.env["HTTP_REFERER"] = "http://example.com"
    end
    let(:examinable_false) do
      {
        examinable: false
      }
    end
    let(:examinable_true) do
      {
        examinable: true
      }
    end
    it 'changes the examinable to false' do
      mcq_stem = FactoryGirl.create :mcq_stem, examinable: true
      get :change_examinable, id: mcq_stem.to_param, mcq_stem: examinable_false, pool_type: 'mcq_pool'
      mcq_stem.reload
      expect(mcq_stem.examinable).to eq false
    end
    it 'changes the examinable to true' do
      mcq_stem = FactoryGirl.create :mcq_stem, examinable: false
      get :change_examinable, id: mcq_stem.to_param, mcq_stem: examinable_true, pool_type: 'exam_pool'
      mcq_stem.reload
      expect(mcq_stem.examinable).to eq true
    end
  end

  describe 'POST update_complete_time' do
    it 'create mcq stem attempt time' do
      exercise = FactoryGirl.create :exercise
      mcq_stem = exercise.mcq_stems.first
      mcq = FactoryGirl.create(:mcq, mcq_stem: mcq_stem)
      expect {
        post :update_complete_time, id: mcq_stem.to_param, sectionable_id: exercise.to_param, sectionable_type: 'Exercise', tot_time: 60
      }.to change(McqAttemptTime, :count).by(1)
      expect(exercise.mcq_stem_attempt_time(mcq_stem.id)).to eq(1.0)
    end
  end
end
