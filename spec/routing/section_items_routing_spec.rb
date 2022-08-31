require 'rails_helper'

RSpec.describe SectionItemsController, type: :routing do
  describe 'routing' do
    context 'when online exam as parent resource' do
      it 'routes to #index' do
        expect(get: '/online_exams/1/sections/1/section_items').to route_to('section_items#index', online_exam_id: '1', section_id: '1')
      end

      it 'routes to #new' do
        expect(get: '/online_exams/1/sections/1/section_items/new').to route_to('section_items#new', online_exam_id: '1', section_id: '1')
      end

      it 'routes to #show' do
        expect(get: '/online_exams/1/sections/1/section_items/1').to route_to('section_items#show', id: '1', online_exam_id: '1', section_id: '1')
      end

      it 'routes to #edit' do
        expect(get: '/online_exams/1/sections/1/section_items/1/edit').to route_to('section_items#edit', id: '1', online_exam_id: '1', section_id: '1')
      end

      it 'routes to #create' do
        expect(post: '/online_exams/1/sections/1/section_items').to route_to('section_items#create', online_exam_id: '1', section_id: '1')
      end

      it 'routes to #update via PUT' do
        expect(put: '/online_exams/1/sections/1/section_items/1').to route_to('section_items#update', id: '1', online_exam_id: '1', section_id: '1')
      end

      it 'routes to #update via PATCH' do
        expect(patch: '/online_exams/1/sections/1/section_items/1').to route_to('section_items#update', id: '1', online_exam_id: '1', section_id: '1')
      end

      it 'routes to #destroy' do
        expect(delete: '/online_exams/1/sections/1/section_items/1').to route_to('section_items#destroy', id: '1', online_exam_id: '1', section_id: '1')
      end
    end
  end
end
