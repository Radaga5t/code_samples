require 'rails_helper'

RSpec.describe Asset, type: :model do
  describe 'association' do
    it { is_expected.to belong_to(:host) }
  end
end
