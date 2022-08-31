require 'rails_helper'

RSpec.describe OnlineExamsController, type: :controller do
  login_superadmin
  let(:valid_attributes) { { title: 'hello', instruction: 'some instruction' } }

  let(:invalid_attributes) { { title: nil } }

  describe 'GET #index' do
    xit 'assigns all online_exams as @online_exams' do
      get :index, {}
      expect(assigns(:online_exams)).to match_array(OnlineExam.all)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested exam as @exam' do
      exam = OnlineExam.create! valid_attributes
      get :show, id: exam.to_param
      expect(assigns(:online_exam)).to eq(exam)
    end
  end

  describe 'GET #new' do
    it 'assigns a new exam as @exam' do
      get :new, {}
      expect(assigns(:online_exam)).to be_a_new(OnlineExam)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested exam as @exam' do
      exam = OnlineExam.create! valid_attributes
      get :edit, id: exam.to_param
      expect(assigns(:online_exam)).to eq(exam)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new OnlineExam' do
        expect do
          post :create, online_exam: valid_attributes
        end.to change(OnlineExam, :count).by(1)
      end

      it 'assigns a newly created exam as @exam' do
        post :create, online_exam: valid_attributes
        expect(assigns(:online_exam)).to be_a(OnlineExam)
        expect(assigns(:online_exam)).to be_persisted
      end

      it 'redirects to the created exam' do
        post :create, online_exam: valid_attributes
        expect(response).to redirect_to(OnlineExam.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved exam as @exam' do
        post :create, online_exam: invalid_attributes
        expect(assigns(:online_exam)).to be_a_new(OnlineExam)
      end

      it "re-renders the 'new' template" do
        post :create, online_exam: invalid_attributes
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { title: 'new title' }
      end

      it 'updates the requested exam' do
        exam = OnlineExam.create! valid_attributes
        put :update, id: exam.to_param, online_exam: new_attributes
        exam.reload
        expect(exam.title).to eq 'new title'
      end

      it 'assigns the requested exam as @exam' do
        exam = OnlineExam.create! valid_attributes
        put :update, id: exam.to_param, online_exam: valid_attributes
        expect(assigns(:online_exam)).to eq(exam)
      end

      it 'redirects to the exam' do
        exam = OnlineExam.create! valid_attributes
        put :update, id: exam.to_param, online_exam: valid_attributes
        expect(response).to redirect_to(edit_online_exam_path(exam))
      end
    end

    context 'with invalid params' do
      it 'assigns the exam as @exam' do
        exam = OnlineExam.create! valid_attributes
        put :update, id: exam.to_param, online_exam: invalid_attributes
        expect(assigns(:online_exam)).to eq(exam)
      end

      it "re-renders the 'edit' template" do
        exam = OnlineExam.create! valid_attributes
        put :update, id: exam.to_param, online_exam: invalid_attributes
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested exam' do
      exam = OnlineExam.create! valid_attributes
      expect do
        delete :destroy, id: exam.to_param
      end.to change(OnlineExam, :count).by(-1)
    end

    it 'redirects to the online_exams list' do
      exam = OnlineExam.create! valid_attributes
      delete :destroy, id: exam.to_param
      expect(response).to redirect_to(online_exams_url)
    end
  end
end
