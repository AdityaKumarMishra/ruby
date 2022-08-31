require 'rails_helper'

RSpec.describe ExercisesController, type: :controller do
  login_student

  let(:tag1) { FactoryGirl.create :tag }
  let!(:mcq_stem) { FactoryGirl.create(:mcq_stem, tag_ids: [tag1.id], difficulty: 30) }

  let(:valid_attributes) do
    FactoryGirl.attributes_for(:exercise, user_id: subject.current_user.id, tag_ids: [tag1.id],
                                          difficulty: :easy)
  end

  let(:invalid_attributes) do
    FactoryGirl.attributes_for(:exercise, amount: -1, user: subject.current_user)
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ExercisesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all exercises as @exercises' do
      exercise = Exercise.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:exercises)).to eq([])
    end
  end

  describe 'GET #new' do
    it 'assigns a new exercise as @exercise' do
      productVer = FactoryGirl.create(:product_version, type: 'GamsatReady')
      course = FactoryGirl.create(:course, product_version_id: productVer.id)
      order = FactoryGirl.create(:order, status: :paid, user: subject.current_user)
      enrolment = FactoryGirl.create(:enrolment)
      paid_purchase_item = FactoryGirl.create(:purchase_item, user: subject.current_user, order: order, purchasable: enrolment)
      announcement = FactoryGirl.create(:announcement, name: 'GamsatReady-dashboard',
                                                       category: 'Dashboardpage', description: 'dashboard announcements'
                                       )
      subject.current_user.active_course = course
      get :new, {}, valid_session
      expect(assigns(:exercise)).to be_a_new(Exercise)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested exercise as @exercise' do
      exercise = Exercise.create! valid_attributes
      get :edit, { id: exercise.to_param }, valid_session
      expect(assigns(:exercise)).to eq(exercise)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Exercise' do
        expect do
          post :create, { exercise: valid_attributes }, valid_session
        end.to change(Exercise, :count).by(1)
      end

      it 'assigns a newly created exercise as @exercise' do
        post :create, { exercise: valid_attributes }, valid_session
        expect(assigns(:exercise)).to be_a(Exercise)
        expect(assigns(:exercise)).to be_persisted
      end

      it 'redirects to the created exercise' do
        post :create, { exercise: valid_attributes }, valid_session
        expect(response).to redirect_to(exercise_mcq_attempts_path(Exercise.last))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved exercise as @exercise' do
        post :create, { exercise: invalid_attributes }, valid_session
        expect(assigns(:exercise)).to be_a_new(Exercise)
      end

      it "re-renders the 'new' template" do
        post :create, { exercise: invalid_attributes }, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { amount: 12 } }

      it 'updates the requested exercise' do
        exercise = Exercise.create! valid_attributes
        put :update, { id: exercise.to_param, exercise: new_attributes }, valid_session
        exercise.reload
        expect(exercise.amount).to eq 12
      end

      it 'assigns the requested exercise as @exercise' do
        exercise = Exercise.create! valid_attributes
        put :update, { id: exercise.to_param, exercise: valid_attributes }, valid_session
        expect(assigns(:exercise)).to eq(exercise)
      end

      it 'redirects to the exercise' do
        exercise = Exercise.create! valid_attributes
        put :update, { id: exercise.to_param, exercise: valid_attributes }, valid_session
        expect(response).to redirect_to(exercise)
      end
    end

    context 'with invalid params' do
      it 'assigns the exercise as @exercise' do
        exercise = Exercise.create! valid_attributes
        put :update, { id: exercise.to_param, exercise: invalid_attributes }, valid_session
        expect(assigns(:exercise)).to eq(exercise)
      end

      it "re-renders the 'edit' template" do
        exercise = Exercise.create! valid_attributes
        put :update, { id: exercise.to_param, exercise: invalid_attributes }, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested exercise' do
      exercise = Exercise.create! valid_attributes
      exercise.update_mcq_statistics_with_delete
      expect {
        delete :destroy, {:id => exercise.to_param}, valid_session
      }.to change(Exercise, :count).by(-1)
    end

    it 'redirects to the exercises list' do
      exercise = Exercise.create! valid_attributes
      delete :destroy, { id: exercise.to_param }, valid_session
      expect(response).to redirect_to(exercises_url)
    end
  end

  describe 'POST #repeat' do
    it 'redirects to the old exercise' do
      exercise = Exercise.create! valid_attributes
      exercise.completed_at = Time.zone.now
      exercise.save!
      post :repeat, { id: exercise.to_param }, valid_session
      expect(assigns(:exercise)).to eq(exercise)
      expect(assigns(:exercise)).to be_persisted
      expect(response).to redirect_to(exercise_mcq_attempts_path(exercise))
    end
  end
end
