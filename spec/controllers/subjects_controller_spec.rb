require 'rails_helper'

RSpec.describe SubjectsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Subject. As you add validations to Subject, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SubjectsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  #Student Authorization
  let!(:tutor) { FactoryGirl.create(:user, :tutor) }
  before { subject.stub(current_user: tutor, authenticate_user!: true) }

  describe "GET #index" do
    it "assigns all subjects as @subjects" do
      subject = Subject.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:subjects)).to eq([subject])
    end
  end

  describe "GET #show" do
    it "assigns the requested subject as @subject" do
      subject = Subject.create! valid_attributes
      get :show, {:id => subject.to_param}, valid_session
      expect(assigns(:subject)).to eq(subject)
    end
  end

  describe "GET #new" do
    it "assigns a new subject as @subject" do
      get :new, {}, valid_session
      expect(assigns(:subject)).to be_a_new(Subject)
    end
  end

  describe "GET #edit" do
    it "assigns the requested subject as @subject" do
      subject = Subject.create! valid_attributes
      get :edit, {:id => subject.to_param}, valid_session
      expect(assigns(:subject)).to eq(subject)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Subject" do
        expect {
          post :create, {:subject => valid_attributes}, valid_session
        }.to change(Subject, :count).by(1)
      end

      it "assigns a newly created subject as @subject" do
        post :create, {:subject => valid_attributes}, valid_session
        expect(assigns(:subject)).to be_a(Subject)
        expect(assigns(:subject)).to be_persisted
      end

      it "redirects to the created subject" do
        post :create, {:subject => valid_attributes}, valid_session
        expect(response).to redirect_to(Subject.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved subject as @subject" do
        post :create, {:subject => invalid_attributes}, valid_session
        expect(assigns(:subject)).to be_a_new(Subject)
      end

      it "re-renders the 'new' template" do
        post :create, {:subject => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested subject" do
        subject = Subject.create! valid_attributes
        put :update, {:id => subject.to_param, :subject => new_attributes}, valid_session
        subject.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested subject as @subject" do
        subject = Subject.create! valid_attributes
        put :update, {:id => subject.to_param, :subject => valid_attributes}, valid_session
        expect(assigns(:subject)).to eq(subject)
      end

      it "redirects to the subject" do
        subject = Subject.create! valid_attributes
        put :update, {:id => subject.to_param, :subject => valid_attributes}, valid_session
        expect(response).to redirect_to(subject)
      end
    end

    context "with invalid params" do
      it "assigns the subject as @subject" do
        subject = Subject.create! valid_attributes
        put :update, {:id => subject.to_param, :subject => invalid_attributes}, valid_session
        expect(assigns(:subject)).to eq(subject)
      end

      it "re-renders the 'edit' template" do
        subject = Subject.create! valid_attributes
        put :update, {:id => subject.to_param, :subject => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested subject" do
      subject = Subject.create! valid_attributes
      expect {
        delete :destroy, {:id => subject.to_param}, valid_session
      }.to change(Subject, :count).by(-1)
    end

    it "redirects to the subjects list" do
      subject = Subject.create! valid_attributes
      delete :destroy, {:id => subject.to_param}, valid_session
      expect(response).to redirect_to(subjects_url)
    end
  end

end
