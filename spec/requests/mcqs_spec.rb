require 'rails_helper'

RSpec.describe 'Mcqs', type: :request do
  describe 'GET /mcq_stems/:id/mcqs' do
    let(:mcq_stem) { FactoryGirl.create :mcq_stem }
    it 'works! (now write some real specs)' do
      get mcq_stem_mcqs_path(mcq_stem)
      expect(response).to have_http_status(302)
    end
  end
end
