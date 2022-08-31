require 'rails_helper'

RSpec.describe McqAttemptsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/exercises/1/mcq_attempts').to route_to('mcq_attempts#index', exercise_id: '1')
    end

    it 'routes to #review' do
      expect(get: '/exercises/1/mcq_attempts/review').to route_to('mcq_attempts#review',
                                                                  exercise_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/exercises/1/mcq_attempts/new').to be_routable
    end

    it 'routes to #show' do
      expect(get: '/exercises/1/mcq_attempts/1').to be_routable
    end

    it 'routes to #edit' do
      expect(get: '/exercises/1/mcq_attempts/1/edit').not_to be_routable
    end

    it 'routes to #create' do
      expect(post: '/exercises/1/mcq_attempts').not_to be_routable
    end

    it 'routes to #update via PUT' do
      expect(put: '/exercises/1/mcq_attempts/1').not_to be_routable
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/exercises/1/mcq_attempts/1').not_to be_routable
    end

    it 'routes to #destroy' do
      expect(delete: '/exercises/1/mcq_attempts/1').not_to be_routable
    end
  end
end
