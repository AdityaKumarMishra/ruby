require 'rails_helper'

RSpec.describe McqAnswersHelper, type: :helper do
  describe '.human_boolean' do
    it 'should return Yes for true' do
      expect(human_boolean(true)).to eq('Yes')
    end

    it 'should return No for true' do
      expect(human_boolean(false)).to eq('No')
    end

    it 'non booleans return Yes' do
      expect(human_boolean('Random string')).to eq('Yes')
    end
  end
end
