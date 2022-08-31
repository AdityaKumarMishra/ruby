require 'rails_helper'

RSpec.describe VodsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'videos').to route_to('vods#index')
    end

    it 'routes to #new' do
      expect(get: 'videos/new').to route_to('vods#new')
    end

    it 'routes to #show' do
      expect(get: 'videos/1').to route_to('vods#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: 'videos/1/edit').to route_to('vods#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: 'videos').to route_to('vods#create')
    end

    it 'routes to #update via PUT' do
      expect(put: 'videos/1').to route_to('vods#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: 'videos/1').to route_to('vods#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: 'videos/1').to route_to('vods#destroy', id: '1')
    end
  end
end
