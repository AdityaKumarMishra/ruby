require 'rails_helper'

RSpec.describe Date do
  describe 'custom date format' do
    let(:date_format) { Date::DATE_FORMATS[:human] }
    let(:date) { Date.today }

    it 'is not nil' do
      expect(date_format).not_to be_nil
    end

    it 'formats data correctly' do
      expect(date.to_s(:human)).to eq date.strftime(date_format)
    end
  end
end
