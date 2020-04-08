require 'rails_helper'

RSpec.describe Country, type: :model do
  let(:country) { create(:country) }

  describe 'association' do
    it { is_expected.to have_many(:users) }
  end

  describe 'globalized #name' do
    I18n.available_locales.each do |locale|
      context "when locale set to :#{locale}" do
        before do
          I18n.locale = locale
        end

        it 'respond to localized accessor' do
          expect(country).to respond_to("name_#{locale}")
        end

        it 'has valid translation' do
          expect(country.name).to eq(country.send("name_#{locale}"))
        end
      end
    end
  end
end
