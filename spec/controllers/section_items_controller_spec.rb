require 'rails_helper'

RSpec.describe SectionItemsController, type: :controller do
  login_superadmin
  let(:online_exam) { FactoryGirl.create :online_exam }
  let(:diagnostic_test) { FactoryGirl.create :diagnostic_test }
  let(:exam_section) { FactoryGirl.create :section, sectionable: online_exam }
  let(:test_section) { FactoryGirl.create :section, sectionable: diagnostic_test }
  let(:mcq_stem) { FactoryGirl.create :mcq_stem, :examinable, published: true }
  let(:mcq_stem2) { FactoryGirl.create :mcq_stem, :examinable, title: "my_mcq_stem", published: true }
  let(:update_mcq_stem) { FactoryGirl.create :mcq_stem, :examinable, published: true }
  let(:mcq) { FactoryGirl.create(:mcq, mcq_stem: mcq_stem) }

  let(:valid_attributes) do
    { section_id: exam_section.to_param, mcq_id: mcq.to_param }
  end

  let(:post_exam_valid_attributes) { [mcq_stem.to_param, mcq_stem2.to_param] }
  let(:valid_attributes_diag) do
    { section_id: test_section.to_param, mcq_id: mcq.to_param }
  end

  let!(:non_examinable_mcq) {FactoryGirl.create(:mcq, :non_examinable)}

  let(:invalid_attributes) do
    { mcq_id: non_examinable_mcq.to_param }
  end

  context 'When diagnostic test' do
    describe 'GET #index' do
      it 'assigns all section_items as @section_items' do
        section_item = SectionItem.create! valid_attributes_diag
        get :index, diagnostic_test_id: diagnostic_test.to_param, section_id: test_section.to_param
        expect(assigns(:section_items)).to eq([section_item])
      end
    end

    describe 'GET #show' do
      it 'assigns the requested section_item as @section_item' do
        section_item = SectionItem.create! valid_attributes_diag
        get :show, id: section_item.to_param, diagnostic_test_id: diagnostic_test.to_param,
                   section_id: test_section.to_param
        expect(assigns(:section_item)).to eq(section_item)
      end
    end

    describe 'GET #new' do
      it 'assigns a new section_item as @section_item' do
        get :new, diagnostic_test_id: diagnostic_test.to_param, section_id: test_section.to_param
        expect(assigns(:section_item)).to be_a_new(SectionItem)
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested section_item as @section_item' do
        section_item = SectionItem.create! valid_attributes_diag
        get :edit, id: section_item.to_param, diagnostic_test_id: diagnostic_test.to_param,
                   section_id: test_section.to_param
        expect(assigns(:section_item)).to eq(section_item)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new SectionItem' do
          expect do
            post :create, mcq_stem_ids: post_exam_valid_attributes,
                          diagnostic_test_id: diagnostic_test.to_param,
                          section_id: test_section.to_param
          end.to change(SectionItem, :count).by(mcq_stem.mcqs.count + mcq_stem2.mcqs.count)
        end

        it 'redirects to the created section_item' do
          post :create, mcq_stem_ids: post_exam_valid_attributes,
                        diagnostic_test_id: diagnostic_test.to_param,
                        section_id: test_section.to_param
          expect(response).to redirect_to(
            edit_diagnostic_test_section_path(diagnostic_test, test_section))
        end
      end

      context 'with invalid params' do
        it "re-renders the 'new' template" do
          post :create, section_item: invalid_attributes,
                        diagnostic_test_id: diagnostic_test.to_param,
                        section_id: test_section.to_param
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let!(:mcq) {FactoryGirl.create(:mcq, examinable: true)}
        let(:new_attributes) do
          { mcq_id: mcq.to_param }
        end
        it 'updates the requested section_item' do
          section_item = SectionItem.create! valid_attributes_diag
          put :update, id: section_item.to_param, section_item: new_attributes,
                       diagnostic_test_id: diagnostic_test.to_param,
                       section_id: test_section.to_param
          section_item.reload
          expect(section_item.mcq_stem).to eq mcq.mcq_stem
        end

        it 'assigns the requested section_item as @section_item' do
          section_item = SectionItem.create! valid_attributes_diag
          put :update, id: section_item.to_param, section_item: valid_attributes_diag,
                       diagnostic_test_id: diagnostic_test.to_param,
                       section_id: test_section.to_param
          expect(assigns(:section_item)).to eq(section_item)
        end

        it 'redirects to the section_item' do
          section_item = SectionItem.create! valid_attributes_diag
          put :update, id: section_item.to_param, section_item: valid_attributes_diag,
                       diagnostic_test_id: diagnostic_test.to_param,
                       section_id: test_section.to_param
          expect(response).to redirect_to(
            diagnostic_test_section_section_item_path(diagnostic_test, test_section,
                                                      section_item))
        end
      end

      context 'with invalid params' do
        it 'assigns the section_item as @section_item' do
          section_item = SectionItem.create! valid_attributes_diag
          put :update, id: section_item.to_param, section_item: invalid_attributes,
                       diagnostic_test_id: diagnostic_test.to_param,
                       section_id: test_section.to_param
          expect(assigns(:section_item)).to eq(section_item)
        end

        it "re-renders the 'edit' template" do
          section_item = SectionItem.create! valid_attributes_diag
          put :update, id: section_item.to_param, section_item: invalid_attributes,
                       diagnostic_test_id: diagnostic_test.to_param,
                       section_id: test_section.to_param
          expect(response).to render_template('edit')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested section_item' do
        section_item = SectionItem.create! valid_attributes_diag
        expect do
          delete :destroy, id: section_item.to_param, diagnostic_test_id: diagnostic_test.to_param,
                           section_id: test_section.to_param
        end.to change(SectionItem, :count).by(-1)
      end

      it 'redirects to the section_items list' do
        section_item = SectionItem.create! valid_attributes_diag
        delete :destroy, id: section_item.to_param, diagnostic_test_id: diagnostic_test.to_param,
                         section_id: test_section.to_param
        expect(response).to redirect_to(edit_diagnostic_test_section_path(diagnostic_test,
                                                                                   test_section))
      end
    end
  end
  context 'when online exam' do
    describe 'GET #index' do
      it 'assigns all section_items as @section_items' do
        section_item = SectionItem.create! valid_attributes
        get :index, online_exam_id: online_exam.to_param, section_id: exam_section.to_param
        expect(assigns(:section_items)).to eq([section_item])
      end
    end

    describe 'GET #show' do
      it 'assigns the requested section_item as @section_item' do
        section_item = SectionItem.create! valid_attributes
        get :show, id: section_item.to_param, online_exam_id: online_exam.to_param,
                   section_id: exam_section.to_param
        expect(assigns(:section_item)).to eq(section_item)
      end
    end

    describe 'GET #new' do
      it 'assigns a new section_item as @section_item' do
        get :new, online_exam_id: online_exam.to_param, section_id: exam_section.to_param
        expect(assigns(:section_item)).to be_a_new(SectionItem)
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested section_item as @section_item' do
        section_item = SectionItem.create! valid_attributes
        get :edit, id: section_item.to_param, online_exam_id: online_exam.to_param,
                   section_id: exam_section.to_param
        expect(assigns(:section_item)).to eq(section_item)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new SectionItem' do
          expect do
            post :create, mcq_stem_ids: post_exam_valid_attributes, online_exam_id: online_exam.to_param,
                          section_id: exam_section.to_param
          end.to change(SectionItem, :count).by(mcq_stem.mcqs.count + mcq_stem2.mcqs.count)
        end

        it 'redirects to the created section_item' do
          post :create, mcq_stem_ids: post_exam_valid_attributes, online_exam_id: online_exam.to_param,
                        section_id: exam_section.to_param
          expect(response).to redirect_to(edit_online_exam_section_path(online_exam,
                                                                                 exam_section))
        end
      end

      context 'with invalid params' do
        it "re-renders the 'new' template" do
          post :create, section_item: invalid_attributes, online_exam_id: online_exam.to_param,
                        section_id: exam_section.to_param
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let!(:mcq) {FactoryGirl.create(:mcq, examinable: true)}

        let(:new_attributes) do
          { mcq_id: mcq.to_param }
        end

        it 'updates the requested section_item' do
          section_item = SectionItem.create! valid_attributes
          put :update, id: section_item.to_param, section_item: new_attributes,
                       online_exam_id: online_exam.to_param, section_id: exam_section.to_param
          section_item.reload
          expect(section_item.mcq_stem).to eq mcq.mcq_stem
        end

        it 'assigns the requested section_item as @section_item' do
          section_item = SectionItem.create! valid_attributes
          put :update, id: section_item.to_param, section_item: valid_attributes,
                       online_exam_id: online_exam.to_param, section_id: exam_section.to_param
          expect(assigns(:section_item)).to eq(section_item)
        end

        it 'redirects to the section_item' do
          section_item = SectionItem.create! valid_attributes
          put :update, id: section_item.to_param, section_item: valid_attributes,
                       online_exam_id: online_exam.to_param, section_id: exam_section.to_param
          expect(response).to redirect_to(online_exam_section_section_item_path(online_exam,
                                                                                exam_section,
                                                                                section_item))
        end
      end

      context 'with invalid params' do
        it 'assigns the section_item as @section_item' do
          section_item = SectionItem.create! valid_attributes
          put :update, id: section_item.to_param, section_item: invalid_attributes,
                       online_exam_id: online_exam.to_param, section_id: exam_section.to_param
          expect(assigns(:section_item)).to eq(section_item)
        end

        it "re-renders the 'edit' template" do
          section_item = SectionItem.create! valid_attributes
          put :update, id: section_item.to_param, section_item: invalid_attributes,
                       online_exam_id: online_exam.to_param, section_id: exam_section.to_param
          expect(response).to render_template('edit')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested section_item' do
        section_item = SectionItem.create! valid_attributes
        expect do
          delete :destroy, id: section_item.to_param, online_exam_id: online_exam.to_param,
                           section_id: exam_section.to_param
        end.to change(SectionItem, :count).by(-1)
      end

      it 'redirects to the section_items list' do
        section_item = SectionItem.create! valid_attributes
        delete :destroy, id: section_item.to_param, online_exam_id: online_exam.to_param,
                         section_id: exam_section.to_param
        expect(response).to redirect_to(edit_online_exam_section_path(online_exam,
                                                                               exam_section))
      end
    end
  end
end
