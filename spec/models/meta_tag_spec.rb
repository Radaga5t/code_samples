require 'rails_helper'

RSpec.describe MetaTag, type: :model do
  describe 'assotiation' do
    it { is_expected.to belong_to(:has_meta_tags) }
  end
end
