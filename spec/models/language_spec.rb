require 'rails_helper'

RSpec.describe Language, type: :model do
  let(:language) { create(:language) }

  describe 'association' do
    it { is_expected.to have_and_belong_to_many(:users) }
    it { is_expected.to have_and_belong_to_many(:tasks) }
  end

  describe 'globalized #name' do
    I18n.available_locales.each do |locale|
      context "when locale set to :#{locale}" do
        before do
          I18n.locale = locale
        end

        it 'respond to localized accessor' do
          expect(language).to respond_to("name_#{locale}")
        end

        it 'has valid translation' do
          expect(language.name).to eq(language.send("name_#{locale}"))
        end
      end
    end
  end
end
