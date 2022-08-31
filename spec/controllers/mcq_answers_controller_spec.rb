require 'rails_helper'

RSpec.describe McqAnswersController, type: :controller do
  login_superadmin

  let!(:mcq) do
    FactoryGirl.create(:mcq_with_answers)
  end

  let(:mcq_stem) { mcq.mcq_stem }

  let(:valid_attributes) do
    FactoryGirl.attributes_for(:mcq_answer, mcq_id: mcq.id)
  end

  let(:invalid_attributes) do
    FactoryGirl.attributes_for(:mcq_answer, answer: '')
  end

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all mcq_answers as @mcq_answers' do
      mcq_answer = McqAnswer.create! valid_attributes
      get :index, mcq_id: mcq.to_param, mcq_stem_id: mcq_stem.to_param
      expect(assigns(:mcq_answers)).to eq([*mcq.mcq_answers, mcq_answer])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested mcq_answer as @mcq_answer' do
      mcq_answer = McqAnswer.create! valid_attributes
      get :show, id: mcq_answer.to_param, mcq_id: mcq.to_param, mcq_stem_id: mcq_stem.to_param
      expect(assigns(:mcq_answer)).to eq(mcq_answer)
    end
  end

  describe 'GET #new' do
    it 'assigns a new mcq_answer as @mcq_answer' do
      get :new, mcq_id: mcq.id, mcq_stem_id: mcq_stem.to_param
      expect(assigns(:mcq_answer)).to be_a_new(McqAnswer)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested mcq_answer as @mcq_answer' do
      mcq_answer = McqAnswer.create! valid_attributes
      get :edit, mcq_id: mcq.id, id: mcq_answer.to_param, mcq_stem_id: mcq_stem.to_param
      expect(assigns(:mcq_answer)).to eq(mcq_answer)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new McqAnswer' do
        expect do
          post :create, mcq_id: mcq.id, mcq_answer: valid_attributes,
                        mcq_stem_id: mcq_stem.to_param
        end.to change(McqAnswer, :count).by(1)
      end

      it 'assigns a newly created mcq_answer as @mcq_answer' do
        post :create, mcq_id: mcq.id, mcq_answer: valid_attributes, mcq_stem_id: mcq_stem.to_param
        expect(assigns(:mcq_answer)).to be_a(McqAnswer)
        expect(assigns(:mcq_answer)).to be_persisted
      end

      it 'redirects to the created mcq_answer' do
        post :create, mcq_id: mcq.id, mcq_answer: valid_attributes, mcq_stem_id: mcq_stem.to_param
        expect(response).to redirect_to(mcq_stem_mcq_mcq_answers_path(mcq_stem, mcq,
                                                                      McqAnswer.last))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved mcq_answer as @mcq_answer' do
        post :create, mcq_id: mcq.id, mcq_answer: invalid_attributes,
                      mcq_stem_id: mcq_stem.to_param
        expect(assigns(:mcq_answer)).to be_a_new(McqAnswer)
      end

      it "re-renders the 'new' template" do
        post :create, mcq_id: mcq.id, mcq_answer: invalid_attributes,
                      mcq_stem_id: mcq_stem.to_param
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        FactoryGirl.attributes_for(:mcq_answer, mcq_id: mcq.id, answer: 'The corrected answer')
      end

      it 'updates the requested mcq_answer' do
        mcq_answer = McqAnswer.create! valid_attributes
        put :update, mcq_id: mcq.id, id: mcq_answer.to_param, mcq_answer: new_attributes,
                     mcq_stem_id: mcq_stem.to_param
        mcq_answer.reload
        expect(mcq_answer.answer).to eq('The corrected answer')
      end

      it 'assigns the requested mcq_answer as @mcq_answer' do
        mcq_answer = McqAnswer.create! valid_attributes
        put :update, mcq_id: mcq.id, id: mcq_answer.to_param, mcq_answer: valid_attributes,
                     mcq_stem_id: mcq_stem.to_param
        expect(assigns(:mcq_answer)).to eq(mcq_answer)
      end

      it 'redirects to the mcq_answer' do
        mcq_answer = McqAnswer.create! valid_attributes
        put :update, mcq_id: mcq.id, id: mcq_answer.to_param, mcq_answer: valid_attributes,
                     mcq_stem_id: mcq_stem.to_param
        expect(response).to redirect_to(mcq_stem_mcq_mcq_answers_path(mcq_stem, mcq, mcq_answer))
      end
    end

    context 'with invalid params' do
      it 'assigns the mcq_answer as @mcq_answer' do
        mcq_answer = McqAnswer.create! valid_attributes
        put :update, mcq_id: mcq.id, id: mcq_answer.to_param, mcq_answer: invalid_attributes,
                     mcq_stem_id: mcq_stem.to_param
        expect(assigns(:mcq_answer)).to eq(mcq_answer)
      end

      it "re-renders the 'edit' template" do
        mcq_answer = McqAnswer.create! valid_attributes
        put :update, mcq_id: mcq.id, id: mcq_answer.to_param, mcq_answer: invalid_attributes,
                     mcq_stem_id: mcq_stem.to_param
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested mcq_answer' do
      mcq_answer = McqAnswer.create! valid_attributes
      expect do
        delete :destroy, mcq_id: mcq.id, id: mcq_answer.to_param, mcq_stem_id: mcq_stem.to_param
      end.to change(McqAnswer, :count).by(-1)
    end

    it 'redirects to the mcq_answers list' do
      mcq_answer = McqAnswer.create! valid_attributes
      delete :destroy, mcq_id: mcq.id, id: mcq_answer.to_param, mcq_stem_id: mcq_stem.to_param
      expect(response).to redirect_to(mcq_stem_mcq_mcq_answers_path(mcq_stem, mcq))
    end
  end
end
