require 'rails_helper'

RSpec.describe DiagnosticTestAttemptsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/diagnostic_test_attempts').to route_to('diagnostic_test_attempts#index')
    end

    it 'routes to #new' do
      expect(get: '/diagnostic_test_attempts/new').to route_to('diagnostic_test_attempts#new')
    end

    it 'routes to #show' do
      expect(get: '/diagnostic_test_attempts/1').to route_to('diagnostic_test_attempts#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/diagnostic_test_attempts/1/edit').not_to be_routable
    end

    it 'routes to #create' do
      expect(post: '/diagnostic_test_attempts').to route_to('diagnostic_test_attempts#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/diagnostic_test_attempts/1').not_to be_routable
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/diagnostic_test_attempts/1').not_to be_routable
    end

    it 'routes to #destroy' do
      expect(delete: '/diagnostic_test_attempts/1').to route_to('diagnostic_test_attempts#destroy', id: '1')
    end
  end
end
