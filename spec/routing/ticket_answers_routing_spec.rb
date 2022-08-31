require 'rails_helper'

RSpec.describe TicketAnswersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/tickets/1/ticket_answers').to route_to('ticket_answers#index', ticket_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/tickets/1/ticket_answers/new').to route_to('ticket_answers#new', ticket_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/tickets/1/ticket_answers/1').to route_to('ticket_answers#show', id: '1', ticket_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/tickets/1/ticket_answers/1/edit').to route_to('ticket_answers#edit', id: '1', ticket_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/tickets/1/ticket_answers').to route_to('ticket_answers#create', ticket_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/tickets/1/ticket_answers/1').to route_to('ticket_answers#update', id: '1', ticket_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/tickets/1/ticket_answers/1').to route_to('ticket_answers#update', id: '1', ticket_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/tickets/1/ticket_answers/1').to route_to('ticket_answers#destroy', id: '1', ticket_id: '1')
    end
  end
end
