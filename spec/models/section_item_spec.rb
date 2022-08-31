require 'rails_helper'

RSpec.describe SectionItem, type: :model do
  let(:section) { FactoryGirl.create :section }
  let(:examinable_mcq) { FactoryGirl.create :mcq}
  let(:section_item) { FactoryGirl.create(:section_item, section: section, mcq: examinable_mcq) }
  let(:non_examinable_mcq) { FactoryGirl.create :mcq, :non_examinable}

  it 'validates presence of section' do
    expect(section_item).to validate_presence_of(:section)
  end

  it 'is not valid for a non examinable mcq' do
    s = section.section_items.build(mcq: non_examinable_mcq)
    expect(s.valid?).to be false
  end

  it 'is valid for a examinable mcq' do
    expect(section.valid?).to be true
  end
end
