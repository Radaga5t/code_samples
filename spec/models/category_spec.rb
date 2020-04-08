# frozen_string_literal: true

require 'rails_helper'

describe Category, type: :model do
  let(:category) { create :category }

  it 'has a valid factory' do
    expect(create(:category)).to be_valid
  end

  describe 'association' do
    it { is_expected.to have_and_belong_to_many(:task_templates) }
    it { is_expected.to have_many(:children).inverse_of(:parent) }
    it { is_expected.to belong_to(:parent).inverse_of(:children).required(false) }
    it { is_expected.to have_many(:tasks).dependent(:nullify) }
    it { is_expected.to have_many(:user_favorite_categories).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:user_favorite_categories) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:slug) }

    context 'when slug is valid' do
      it { expect(category.slug).to match(/\A[a-z0-9][a-z0-9\-_]+\z/) }
    end

    context 'when slug is invalid' do
      subject(:invalid_category) { build :category, :invalid }

      it { expect(invalid_category.slug).not_to match(/\A[a-z0-9][a-z0-9\-_]+\z/) }
    end
  end

  context 'when created' do
    subject(:child) { create(:category, :child) }

    it 'have depth_level greater than parent' do
      expect(child.depth_level).to be > child.parent.depth_level
    end
  end
end
