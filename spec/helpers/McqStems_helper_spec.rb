require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the McqStemsHelper. For example:
#
# describe McqStemsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe McqStemsHelper, type: :helper do
  describe '#average_rating' do
    let!(:user) { FactoryGirl.create :user }
    let!(:mcq_stem){FactoryGirl.create(:mcq_stem, status: 'published', examinable: true)}
    let!(:mcq){FactoryGirl.create :mcq_with_answers, mcq_stem_id: mcq_stem.id}
    let!(:rating_cache){FactoryGirl.create :rating_cache, cacheable_id: mcq.id, cacheable_type: "Mcq"}
    it 'should return average rating  for mcq_stem' do
      expect(average_rating(mcq_stem) ).to eq (rating_cache.avg)
    end

    describe '#disable_status?' do
      let!(:product_line) { FactoryGirl.create(:product_line) }
      let!(:online_exam) { FactoryGirl.create(:online_exam, position: 1, product_line_id: product_line.id) }
      let!(:section) { FactoryGirl.create(:section, sectionable_id: online_exam.id, sectionable_type: 'OnlineExam') }
      let!(:section_item) { FactoryGirl.create(:section_item, section_id: section.id, mcq_id: mcq.id) }
      let!(:options) { { edit_stem: true } }
      let!(:params) { { mcq_stem: { status: 'published' } } }

      before do
        online_exam.update!(published: true)
      end

      it 'returns the right results' do
        expect(helper.disable_status?(mcq_stem, params, options)).to eq(['published', true])
      end
    end
  end
end
