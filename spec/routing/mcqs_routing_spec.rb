require 'rails_helper'

RSpec.describe McqsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/mcq_stems/1/mcqs').to route_to('mcqs#index', mcq_stem_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/mcq_stems/1/mcqs/new').to route_to('mcqs#new', mcq_stem_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/mcq_stems/1/mcqs/1').to route_to('mcqs#show', id: '1', mcq_stem_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/mcq_stems/1/mcqs/1/edit').to route_to('mcqs#edit', id: '1', mcq_stem_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/mcq_stems/1/mcqs').to route_to('mcqs#create', mcq_stem_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/mcq_stems/1/mcqs/1').to route_to('mcqs#update', id: '1', mcq_stem_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/mcq_stems/1/mcqs/1').to route_to('mcqs#update', id: '1', mcq_stem_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/mcq_stems/1/mcqs/1').to route_to('mcqs#destroy', id: '1', mcq_stem_id: '1')
    end
  end
end
