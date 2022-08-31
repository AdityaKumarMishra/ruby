require 'rails_helper'

RSpec.describe SectionsController, type: :routing do
  describe 'routing' do
    context 'when online exam as parent resource' do
      it 'routes to #index' do
        expect(get: '/online_exams/1/sections').to route_to('sections#index', online_exam_id: '1')
      end

      it 'routes to #new' do
        expect(get: '/online_exams/1/sections/new').to route_to('sections#new',
                                                                online_exam_id: '1')
      end

      it 'routes to #show' do
        expect(get: '/online_exams/1/sections/1').to route_to('sections#show', id: '1',
                                                                               online_exam_id: '1')
      end

      it 'routes to #edit' do
        expect(get: '/online_exams/1/sections/1/edit').to route_to('sections#edit',
                                                                   id: '1', online_exam_id: '1')
      end

      it 'routes to #create' do
        expect(post: '/online_exams/1/sections').to route_to('sections#create',
                                                             online_exam_id: '1')
      end

      it 'routes to #update via PUT' do
        expect(put: '/online_exams/1/sections/1').to route_to('sections#update',
                                                              id: '1', online_exam_id: '1')
      end

      it 'routes to #update via PATCH' do
        expect(patch: '/online_exams/1/sections/1').to route_to('sections#update',
                                                                id: '1', online_exam_id: '1')
      end

      it 'routes to #destroy' do
        expect(delete: '/online_exams/1/sections/1').to route_to('sections#destroy',
                                                                 id: '1', online_exam_id: '1')
      end
    end
  end

  context 'when diagnostic_test as parent resouce' do
    it 'routes to #index' do
      expect(get: '/diagnostic_tests/1/sections').to route_to('sections#index', diagnostic_test_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/diagnostic_tests/1/sections/new').to route_to('sections#new',
                                                                  diagnostic_test_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/diagnostic_tests/1/sections/1').to route_to('sections#show', id: '1',
                                                                                 diagnostic_test_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/diagnostic_tests/1/sections/1/edit').to route_to('sections#edit',
                                                                     id: '1', diagnostic_test_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/diagnostic_tests/1/sections').to route_to('sections#create',
                                                               diagnostic_test_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/diagnostic_tests/1/sections/1').to route_to('sections#update',
                                                                id: '1', diagnostic_test_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/diagnostic_tests/1/sections/1').to route_to('sections#update',
                                                                  id: '1', diagnostic_test_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/diagnostic_tests/1/sections/1').to route_to('sections#destroy',
                                                                   id: '1', diagnostic_test_id: '1')
    end
  end
end
