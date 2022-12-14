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

RSpec.describe AppointmentsController, type: :controller do
  login_student
  # This should return the minimal set of attributes required to create a valid
  # Appointment. As you add validations to Appointment, be sure to
  # adjust the attributes here as well.
  let!(:student) { FactoryGirl.create(:user, :student) }
  let!(:tutor) { FactoryGirl.create(:user, :tutor) }
  let(:valid_attributes) {
    FactoryGirl.attributes_for(:appointment, student_id: subject.current_user.id, tutor_id: tutor.id, content: 'Hi Tutor')
  }

  before do
    subject.current_user.stub(:private_tutor_time_left) { 1 }
  end

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let!(:productVer) { FactoryGirl.create(:product_version) }
  let!(:master_feature1) { FactoryGirl.create(:master_feature, name: 'GamsatPrivateTutoringFeature') }
  let!(:order) { FactoryGirl.create(:order, status: :paid, user: subject.current_user) }
  let!(:pvfp1) do
    FactoryGirl.create(:product_version_feature_price,
                       master_feature: master_feature1,
                       product_version: productVer, is_default: true
                      )
  end

  let!(:course1) { FactoryGirl.create(:course, product_version: productVer) }
  let(:appointment) { FactoryGirl.create(:appointment, student_id: subject.current_user.id, tutor_id: tutor.id, content: 'Hi Tutor', course_id: course1.id) }

  let!(:enrolment) { FactoryGirl.create(:enrolment, course: course1) }

  # current user feature logs
  let!(:feature_log1) do
    FactoryGirl.create(:feature_log,
                       product_version_feature_price:
                      pvfp1, acquired: DateTime.now, enrolment: enrolment, qty: 5
                      )
  end
  let!(:paid_purchase_item) { FactoryGirl.create(:purchase_item, user: subject.current_user, order: order, purchasable: enrolment) }


  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AppointmentsController. Be sure to keep this updated too.
  let(:valid_session) { {'HTTP_REFERER' => 'http://test.com'} }

  describe "GET #index" do
    it "assigns all appointments as @appointments" do
      get :index, {}, valid_session
      expect(assigns(:appointments)).to eq([appointment])
    end
  end

  describe "GET #show" do
    it "assigns the requested appointment as @appointment" do
      get :show, {:id => appointment.id}, valid_session
      expect(assigns(:appointment)).to eq(appointment)
    end
  end

  describe "DELETE #destroy" do
    it "deletes the appointment and sends out cancel email" do
      delete :destroy, params: { id: appointment.id }
      expect(appointment.reload.status).to eq('deleted')
    end
  end

  describe "GET #new" do
    it "assigns a new appointment as @appointment" do
      get :new, {}, valid_session
      expect(assigns(:appointment)).to be_a_new(Appointment)
    end
  end

  describe "GET #edit" do
    it "assigns the requested appointment as @appointment" do
      get :edit, {:id => appointment.id}, valid_session
      expect(assigns(:appointment)).to eq(appointment)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Appointment" do
        subject.current_user.update_attribute(:active_course_id, course1.id)
        expect {
          post :create, {:appointment => valid_attributes}, valid_session
        }.to change(Appointment, :count).by(1)
      end

      it "assigns a newly created appointment as @appointment" do
        subject.current_user.update_attribute(:active_course_id, course1.id)
        post :create, {:appointment => valid_attributes}, valid_session
        expect(assigns(:appointment)).to be_a(Appointment)
        expect(assigns(:appointment)).to be_persisted
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved appointment as @appointment" do
        post :create, {:appointment => invalid_attributes}, valid_session
        expect(assigns(:appointment)).to be_a_new(Appointment)
      end

      it "re-renders the 'new' template" do
        post :create, {:appointment => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested appointment" do
        put :update, {:id => appointment.id, :appointment => new_attributes}, valid_session
        appointment.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested appointment as @appointment" do
        put :update, {:id => appointment.id, :appointment => valid_attributes}, valid_session
        expect(assigns(:appointment)).to eq(appointment)
      end
    end

    context "with invalid params" do
      it "assigns the appointment as @appointment" do
        put :update, {:id => appointment.id, :appointment => invalid_attributes}, valid_session
        expect(assigns(:appointment)).to eq(appointment)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => appointment.id, :appointment => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end
end
