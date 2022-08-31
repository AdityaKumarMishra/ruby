require 'rails_helper'

RSpec.describe SectionsController, type: :controller do
  login_superadmin
  let(:online_exam) { FactoryGirl.create :online_exam }
  let(:diagnostic_test) { FactoryGirl.create :diagnostic_test, sections: []}
  #
  # Using polymorphic associations in combination with single table inheritance
  # (STI) is a little tricky. In order for the associations to work as expected,
  # ensure that you store the base model for the STI models in the type column
  # of the polymorphic association.
  #
  let(:valid_attributes) do
    FactoryGirl.attributes_for(:section, sectionable_type: online_exam.class.base_class.name,
                                         sectionable_id: online_exam.id)
  end

  let(:valid_attributes_with_diag) do
    FactoryGirl.attributes_for(:section, sectionable_type: diagnostic_test.class.base_class.name,
                                         sectionable_id: diagnostic_test.id)
  end

  let(:invalid_attributes) do
    {
      title: nil
    }
  end
  context 'when online exam as parent resource' do
    describe 'GET #index' do
      it 'assigns all sections as @sections' do
        section = Section.create! valid_attributes
        get :index, online_exam_id: online_exam.to_param
        expect(assigns(:sections)).to eq([section])
      end
    end

    describe 'GET #show' do
      it 'assigns the requested section as @section' do
        section = Section.create! valid_attributes
        get :show, id: section.to_param, online_exam_id: online_exam.to_param
        expect(assigns(:section)).to eq(section)
      end
    end

    describe 'GET #new' do
      it 'assigns a new section as @section' do
        get :new, online_exam_id: online_exam.to_param
        expect(assigns(:section)).to be_a_new(Section)
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested section as @section' do
        section = Section.create! valid_attributes
        get :edit, id: section.to_param, online_exam_id: online_exam.to_param
        expect(assigns(:section)).to eq(section)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Section' do
          expect do
            post :create, section: FactoryGirl.attributes_for(:section), online_exam_id: online_exam.to_param
          end.to change(Section, :count).by(1)
        end

        it 'assigns a newly created section as @section' do
          post :create, section: FactoryGirl.attributes_for(:section), online_exam_id: online_exam.to_param
          expect(assigns(:section)).to be_a(Section)
          expect(assigns(:section)).to be_persisted
        end

        it 'redirects to the created section' do
          post :create, section: FactoryGirl.attributes_for(:section), online_exam_id: online_exam.to_param
          expect(response).to redirect_to(edit_online_exam_path(online_exam))
        end
      end

      context 'with invalid params' do
        it 'assigns a newly created but unsaved section as @section' do
          post :create, section: invalid_attributes, online_exam_id: online_exam.to_param
          expect(assigns(:section)).to be_a_new(Section)
        end

        it "re-renders the 'new' template" do
          post :create, section: invalid_attributes, online_exam_id: online_exam.to_param
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          { duration: 30 }
        end

        it 'updates the requested section' do
          section = Section.create! valid_attributes
          put :update, id: section.to_param, section: new_attributes,
                       online_exam_id: online_exam.to_param
          section.reload
          expect(section.duration).to eq 30
        end

        it 'assigns the requested section as @section' do
          section = Section.create! valid_attributes
          put :update, id: section.to_param, section: valid_attributes,
                       online_exam_id: online_exam.to_param
          expect(assigns(:section)).to eq(section)
        end

        it 'redirects to the section' do
          section = Section.create! valid_attributes
          put :update, id: section.to_param, section: valid_attributes,
                       online_exam_id: online_exam.to_param
          expect(response).to redirect_to(edit_online_exam_section_path(online_exam, section))
        end
      end

      context 'with invalid params' do
        it 'assigns the section as @section' do
          section = Section.create! valid_attributes
          put :update, id: section.to_param, section: invalid_attributes,
                       online_exam_id: online_exam.to_param
          expect(assigns(:section)).to eq(section)
        end

        it "re-renders the 'edit' template" do
          section = Section.create! valid_attributes
          put :update, id: section.to_param, section: invalid_attributes,
                       online_exam_id: online_exam.to_param
          expect(response).to render_template('edit')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested section' do
        section = Section.create! valid_attributes
        expect do
          delete :destroy, id: section.to_param, online_exam_id: online_exam.to_param
        end.to change(Section, :count).by(-1)
      end

      it 'redirects to the sections list' do
        section = Section.create! valid_attributes
        delete :destroy, id: section.to_param, online_exam_id: online_exam.to_param
        expect(response).to redirect_to(edit_online_exam_url(online_exam))
      end
    end
  end
  context 'when diagnostic_test as parent resource' do
    describe 'GET #index' do
      it 'assigns all sections as @sections' do
        section = Section.create! valid_attributes_with_diag
        get :index, diagnostic_test_id: diagnostic_test.to_param
        expect(assigns(:sections)).to eq([section])
      end
    end

    describe 'GET #show' do
      it 'assigns the requested section as @section' do
        section = Section.create! valid_attributes_with_diag
        get :show, id: section.to_param, diagnostic_test_id: diagnostic_test.to_param
        expect(assigns(:section)).to eq(section)
      end
    end

    describe 'GET #new' do
      it 'assigns a new section as @section' do
        get :new, diagnostic_test_id: diagnostic_test.to_param
        expect(assigns(:section)).to be_a_new(Section)
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested section as @section' do
        section = Section.create! valid_attributes_with_diag
        get :edit, id: section.to_param, diagnostic_test_id: diagnostic_test.to_param
        expect(assigns(:section)).to eq(section)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Section' do
          expect do
            post :create, section: valid_attributes_with_diag, diagnostic_test_id: diagnostic_test.to_param
          end.to change(Section, :count).by(1)
        end

        it 'assigns a newly created section as @section' do
          post :create, section: valid_attributes_with_diag, diagnostic_test_id: diagnostic_test.to_param
          expect(assigns(:section)).to be_a(Section)
          expect(assigns(:section)).to be_persisted
        end

        it 'redirects to the created section' do
          post :create, section: valid_attributes_with_diag, diagnostic_test_id: diagnostic_test.to_param
          expect(response).to redirect_to(edit_diagnostic_test_path(diagnostic_test))
        end
      end

      context 'with invalid params' do
        it 'assigns a newly created but unsaved section as @section' do
          post :create, section: invalid_attributes, diagnostic_test_id: diagnostic_test.to_param
          expect(assigns(:section)).to be_a_new(Section)
        end

        it "re-renders the 'new' template" do
          post :create, section: invalid_attributes, diagnostic_test_id: diagnostic_test.to_param
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          { duration: 30 }
        end

        it 'updates the requested section' do
          section = Section.create! valid_attributes_with_diag
          put :update, id: section.to_param, section: new_attributes,
                       diagnostic_test_id: diagnostic_test.to_param
          section.reload
          expect(section.duration).to eq 30
        end

        it 'assigns the requested section as @section' do
          section = Section.create! valid_attributes_with_diag
          put :update, id: section.to_param, section: valid_attributes_with_diag,
                       diagnostic_test_id: diagnostic_test.to_param
          expect(assigns(:section)).to eq(section)
        end

        it 'redirects to the section' do
          section = Section.create! valid_attributes_with_diag
          put :update, id: section.to_param, section: valid_attributes_with_diag,
                       diagnostic_test_id: diagnostic_test.to_param
          expect(response).to redirect_to(edit_diagnostic_test_section_path(diagnostic_test, section))
        end
      end

      context 'with invalid params' do
        it 'assigns the section as @section' do
          section = Section.create! valid_attributes_with_diag
          put :update, id: section.to_param, section: invalid_attributes,
                       diagnostic_test_id: diagnostic_test.to_param
          expect(assigns(:section)).to eq(section)
        end

        it "re-renders the 'edit' template" do
          section = Section.create! valid_attributes_with_diag
          put :update, id: section.to_param, section: invalid_attributes,
                       diagnostic_test_id: diagnostic_test.to_param
          expect(response).to render_template('edit')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested section' do
        section = Section.create! valid_attributes_with_diag
        expect do
          delete :destroy, id: section.to_param, diagnostic_test_id: diagnostic_test.to_param
        end.to change(Section, :count).by(-1)
      end

      it 'redirects to the sections list' do
        section = Section.create! valid_attributes_with_diag
        delete :destroy, id: section.to_param, diagnostic_test_id: diagnostic_test.to_param
        expect(response).to redirect_to(edit_diagnostic_test_url(diagnostic_test))
      end
    end
  end
end
