require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user_role_user) { create(:user_role_user) }
  let(:user_role_administrator) { create(:user_role_administrator) }
  let(:user) { create(:user) }

  before do
    user_role_user && user_role_administrator
  end

  it 'has a valid factory' do
    expect(create(:user)).to be_valid
  end

  describe 'association' do
    it { is_expected.to have_many(:user_services) }
    it { is_expected.to have_one(:user_account).dependent(:destroy) }
    it { is_expected.to have_many(:user_socials).dependent(:destroy) }
    it { is_expected.to have_one(:user_verification).dependent(:destroy) }
    it { is_expected.to have_one(:legal_entity).dependent(:destroy) }
    it { is_expected.to have_and_belong_to_many(:languages) }
    it { is_expected.to belong_to(:country).optional }
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
    it { is_expected.to have_many(:task_responses).dependent(:destroy) }
    it { is_expected.to have_one(:user_rating).dependent(:destroy) }
    it { is_expected.to have_many(:user_in_category_ratings) }
    it { is_expected.to have_many(:user_reviews).inverse_of(:author).dependent(:nullify) }
    it { is_expected.to have_many(:reviews).class_name('UserReview') }
    it { is_expected.to have_and_belong_to_many(:user_chats) }
    it { is_expected.to have_many(:user_chat_messages).dependent(:nullify) }
    it { is_expected.to have_one(:user_view_statistic).dependent(:destroy) }
  end

  describe 'enum' do
    it { is_expected.to define_enum_for(:sex) }
    it { is_expected.to define_enum_for(:user_type) }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'monetize' do
    it { is_expected.to monetize(:price_per_hour).allow_nil }
  end

  describe 'assets' do
    include_examples 'has image asset',
                     :photo,
                     resize: [:resize_to_limit, 640, 640],
                     versions: {
                       large: [:resize_to_fill, 320, 320],
                       small: [:resize_to_fill, 120, 120]
                     }
  end

  describe 'default_scope' do
    subject(:users) { described_class.all }

    before do
      create_list(:user, 2)
    end

    it 'new users first' do
      expect(users.first.created_at).to be > users.second.created_at
    end
  end

  it_behaves_like 'immutable', factory: :user

  describe '#user_account' do
    subject(:user_account) { user.user_account }

    it 'return UserAccount instance' do
      expect(user_account).to be_kind_of UserAccount
    end

    it 'return valid user_account' do
      expect(user_account).to be_valid
    end

    it 'return user_account with zero amount' do
      expect(user_account.amount).to eql Money.new(0, 'CRD')
    end
  end

  describe '#user_verification' do
    subject(:user_verification) { user.user_verification }

    it 'return UserVerification instance' do
      expect(user_verification).to be_kind_of UserVerification
    end

    it 'return valid user_verification' do
      expect(user_verification).to be_valid
    end
  end

  describe '#user_view_statistic' do
    subject(:user_view_statistic) { user.user_view_statistic }

    it 'return UserViewStatistic instance' do
      expect(user_view_statistic).to be_kind_of UserViewStatistic
    end

    it 'return valid user_view_statistic' do
      expect(user_view_statistic).to be_valid
    end
  end

  describe '#user_was_viewed' do
    it 'add 1 to counter' do
      expect { user.user_was_viewed }.to(
        change(user.user_view_statistic, :user_view_count).by(1)
      )
    end
  end

  describe '#legal_entity' do
    context 'when user type is a legal entity' do
      subject(:legal_entity) { create(:user, :legal_entity).legal_entity }

      it 'return UserRating instance' do
        expect(legal_entity).to be_kind_of LegalEntity
      end

      it 'return valid legal_entity' do
        expect(legal_entity).to be_valid
      end
    end

    context 'when user type is individual' do
      subject(:legal_entity) { create(:user).legal_entity }

      it 'return nil' do
        expect(legal_entity).not_to be_truthy
      end
    end
  end

  describe '#country' do
    context 'when user selected country' do
      subject(:country) { create(:user, :from_russia).country }

      it 'return Country instance' do
        expect(country).to be_kind_of Country
      end

      it 'return valid country' do
        expect(country).to be_valid
      end
    end
  end

  describe '#languages' do
    context 'when user has not selected any language' do
      subject(:languages) { create(:user).languages }

      it 'is empty' do
        expect(languages).to be_empty
      end
    end

    context 'when user selected languages' do
      subject(:languages) { create(:user, :has_2_lang).languages }

      it 'return 2 languages' do
        expect(languages.size).to be 2
      end

      it 'return Russian and English languages' do
        expect(languages).to include(have_attributes(name_en: 'Russian'),
                                     have_attributes(name_en: 'English'))
      end
    end
  end

  describe '#user_rating' do
    subject(:user_rating) { user.user_rating }

    it 'return UserRating instance' do
      expect(user_rating).to be_kind_of UserRating
    end

    it 'return valid user_rating' do
      expect(user_rating).to be_valid
    end
  end

  describe 'Devise confirmable' do
    context 'when user email is not confirmed' do
      it 'confirmed? return false' do
        expect(user).not_to be_confirmed
      end
    end

    context 'when user email is confirmed' do
      before do
        user.confirm
      end

      it 'confirmed? return true' do
        expect(user).to be_confirmed
      end
    end
  end
end
