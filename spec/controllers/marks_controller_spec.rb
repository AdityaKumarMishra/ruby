require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe MarksController, type: :controller do
  login_tutor
  # This should return the minimal set of attributes required to create a valid
  # Mark. As you add validations to Mark, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MarksController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all marks as @marks" do
      mark = Mark.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:marks)).to eq([mark])
    end
  end

  describe "GET #show" do
    it "assigns the requested mark as @mark" do
      mark = Mark.create! valid_attributes
      get :show, {:id => mark.to_param}, valid_session
      expect(assigns(:mark)).to eq(mark)
    end
  end

  xdescribe "GET #new" do
    it "assigns a new mark as @mark" do
      get :new, {}, valid_session
      expect(assigns(:mark)).to be_a_new(Mark)
    end
  end

  describe "GET #edit" do
    it "assigns the requested mark as @mark" do
      mark = Mark.create! valid_attributes
      get :edit, {:id => mark.to_param}, valid_session
      expect(assigns(:mark)).to eq(mark)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Mark" do
        expect {
          post :create, {:mark => valid_attributes}, valid_session
        }.to change(Mark, :count).by(1)
      end

      it "assigns a newly created mark as @mark" do
        post :create, {:mark => valid_attributes}, valid_session
        expect(assigns(:mark)).to be_a(Mark)
        expect(assigns(:mark)).to be_persisted
      end

      it "redirects to the created mark" do
        post :create, {:mark => valid_attributes}, valid_session
        expect(response).to redirect_to(Mark.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved mark as @mark" do
        post :create, {:mark => invalid_attributes}, valid_session
        expect(assigns(:mark)).to be_a_new(Mark)
      end

      it "re-renders the 'new' template" do
        post :create, {:mark => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested mark" do
        mark = Mark.create! valid_attributes
        put :update, {:id => mark.to_param, :mark => new_attributes}, valid_session
        mark.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested mark as @mark" do
        mark = Mark.create! valid_attributes
        put :update, {:id => mark.to_param, :mark => valid_attributes}, valid_session
        expect(assigns(:mark)).to eq(mark)
      end

      it "redirects to the mark" do
        mark = Mark.create! valid_attributes
        put :update, {:id => mark.to_param, :mark => valid_attributes}, valid_session
        expect(response).to redirect_to(mark)
      end
    end

    context "with invalid params" do
      it "assigns the mark as @mark" do
        mark = Mark.create! valid_attributes
        put :update, {:id => mark.to_param, :mark => invalid_attributes}, valid_session
        expect(assigns(:mark)).to eq(mark)
      end

      it "re-renders the 'edit' template" do
        mark = Mark.create! valid_attributes
        put :update, {:id => mark.to_param, :mark => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested mark" do
      mark = Mark.create! valid_attributes
      expect {
        delete :destroy, {:id => mark.to_param}, valid_session
      }.to change(Mark, :count).by(-1)
    end

    it "redirects to the marks list" do
      mark = Mark.create! valid_attributes
      delete :destroy, {:id => mark.to_param}, valid_session
      expect(response).to redirect_to(marks_url)
    end
  end

end
