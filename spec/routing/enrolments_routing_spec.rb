require 'rails_helper'

RSpec.describe EnrolmentsController, type: :routing do
  describe 'routing' do
    let!(:user) { FactoryGirl.create(:user) }

    it 'routes to #new' do
      expect(get: "/users/#{user.id}/enrolments/new").to route_to('enrolments#new', user_id: user.id.to_s)
    end

    it 'routes to #show' do
      expect(get: "/users/#{user.id}/enrolments/1").to route_to('enrolments#show', id: '1', user_id: user.id.to_s)
    end

    it 'routes to #edit' do
      expect(get: "/users/#{user.id}/enrolments/1/edit").to route_to('enrolments#edit', id: '1', user_id: user.id.to_s)
    end

    it 'routes to #create' do
      expect(post: "/users/#{user.id}/enrolments").to route_to('enrolments#create', user_id: user.id.to_s)
    end

    it 'routes to #update via PUT' do
      expect(put: "/users/#{user.id}/enrolments/1").to route_to('enrolments#update', id: '1', user_id: user.id.to_s)
    end

    it 'routes to #update via PATCH' do
      expect(patch: "/users/#{user.id}/enrolments/1").to route_to('enrolments#update', id: '1', user_id: user.id.to_s)
    end

    it 'routes to #destroy' do
      expect(delete: "/users/#{user.id}/enrolments/1").to route_to('enrolments#destroy', id: '1', user_id: user.id.to_s)
    end
  end
end
