require 'rails_helper'

RSpec.describe McqAnswersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/mcq_stems/1/mcqs/1/answers').to route_to('mcq_answers#index', mcq_id: '1',
                                                                                  mcq_stem_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/mcq_stems/1/mcqs/1/answers/new').to route_to(
        'mcq_answers#new', mcq_id: '1', mcq_stem_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/mcq_stems/1/mcqs/1/answers/1').to route_to(
        'mcq_answers#show', mcq_id: '1', id: '1', mcq_stem_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/mcq_stems/1/mcqs/1/answers/1/edit').to route_to('mcq_answers#edit',
                                                                    mcq_id: '1', id: '1',
                                                                    mcq_stem_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/mcq_stems/1/mcqs/1/answers').to route_to(
        'mcq_answers#create', mcq_id: '1', mcq_stem_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/mcq_stems/1/mcqs/1/answers/1').to route_to(
        'mcq_answers#update', mcq_id: '1', id: '1', mcq_stem_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/mcq_stems/1/mcqs/1/answers/1').to route_to(
        'mcq_answers#update', mcq_id: '1', id: '1', mcq_stem_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/mcq_stems/1/mcqs/1/answers/1').to route_to(
        'mcq_answers#destroy', mcq_id: '1', id: '1', mcq_stem_id: '1')
    end
  end
end
