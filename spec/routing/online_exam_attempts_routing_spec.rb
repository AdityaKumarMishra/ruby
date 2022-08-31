require 'rails_helper'

RSpec.describe OnlineExamAttemptsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/online_exam_attempts').to route_to('online_exam_attempts#index')
    end

    it 'routes to #new' do
      expect(get: '/online_exam_attempts/new').to route_to('online_exam_attempts#new')
    end

    it 'routes to #show' do
      expect(get: '/online_exam_attempts/1').to route_to('online_exam_attempts#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/online_exam_attempts/1/edit').not_to be_routable
    end

    it 'routes to #create' do
      expect(post: '/online_exam_attempts').to route_to('online_exam_attempts#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/online_exam_attempts/1').not_to be_routable
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/online_exam_attempts/1').not_to be_routable
    end

    it 'routes to #destroy' do
      expect(delete: '/online_exam_attempts/1').to route_to('online_exam_attempts#destroy', id: '1')
    end
  end
end
