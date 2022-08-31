require 'rails_helper'

RSpec.describe OnlineExamsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/online_exams').to route_to('online_exams#index')
    end

    it 'routes to #new' do
      expect(get: '/online_exams/new').to route_to('online_exams#new')
    end

    it 'routes to #show' do
      expect(get: '/online_exams/1').to route_to('online_exams#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/online_exams/1/edit').to route_to('online_exams#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/online_exams').to route_to('online_exams#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/online_exams/1').to route_to('online_exams#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/online_exams/1').to route_to('online_exams#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/online_exams/1').to route_to('online_exams#destroy', id: '1')
    end
  end
end
