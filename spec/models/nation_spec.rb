require 'rails_helper'

RSpec.describe Nation, type: :model do
  subject { build(:nation) }

  it { should belong_to(:account) }

  it { should validate_presence_of(:slug) }
  it { should validate_uniqueness_of(:slug) }
end
