# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_and_belong_to_many(:languages) }
    it { is_expected.to have_one(:user_service).dependent(:destroy).class_name('Services::SingleOffers::UserTaskService').inverse_of(:task) }
    it { is_expected.to have_many(:task_responses).dependent(:destroy) }
    it { is_expected.to have_one(:task_view_statistic).dependent(:destroy) }
    it { is_expected.to have_many(:user_reviews).dependent(:nullify) }
    it { is_expected.to have_many(:user_chats).dependent(:destroy) }
  end

  describe 'monetize' do
    it { is_expected.to monetize(:budget) }
    it { is_expected.to monetize(:commission) }
  end

  describe 'enum' do
    it { is_expected.to define_enum_for(:payment_method) }
    it { is_expected.to define_enum_for(:task_date_type) }
  end

  describe '#unique_id' do
    context 'when record is new' do
      subject(:unique_id) { create(:task).unique_id }

      it 'return BSON::ObjectId' do
        expect(unique_id).to match(/[0-9a-fA-F]{24}/)
      end
    end

    context 'when record is not draft' do
      let(:task) { create(:task) }

      it 'return (::starting_id + .id) equal string' do
        task.publish
        expect(task.unique_id).to eq((task.id + described_class.starting_id).to_s)
      end
    end
  end

  describe '#who_pays' do
    let(:user) { create(:user, :user) }
    let(:task) { create(:task, user: user) }

    it 'respond to who_pays' do
      expect(task).to respond_to :who_pays
    end

    context 'when user subscription is present' do
      let(:subscription) { create(:subscription, :for_30_days) }

      before do
        user.user_account.amount = Money.new(10_000, 'CRD')
        user.user_account.new_subscription(subscription).process
      end

      it 'return :partner_pays' do
        expect(task.who_pays).to eq :partner_pays
      end
    end
  end

  describe '#who_pays=' do
    let(:user) { create(:user, :user) }
    let(:task) { create(:task, user: user) }

    context 'when user subscription is present' do
      let(:subscription) { create(:subscription, :for_30_days) }

      before do
        user.user_account.amount = Money.new(10_000, 'CRD')
        user.user_account.new_subscription(subscription).process
      end

      it 'raise Tasks::Errors::WhoPaysReadOnly' do
        expect { task.who_pays = :fifty_fifty }.to raise_error(Tasks::Errors::WhoPaysReadOnly)
      end
    end
  end

  describe '#selected_task_response' do
    let(:task) { create(:task) }
    let(:task_response) { create(:task_response, task: task) }

    before do
      task.publish
      task_response.publish
      task_response.select
    end

    it 'return task_response' do
      expect(task.selected_task_response.first.id).to eq(task_response.id)
    end
  end

  describe '#selected_task_response_exist?' do
    let(:task) { create(:task) }
    let(:task_response) { create(:task_response, task: task) }

    before do
      task.publish
      task_response.publish
      task_response.select
    end

    it 'return task_response' do
      expect(task.selected_task_response_exist?).to be_truthy
    end
  end
end
