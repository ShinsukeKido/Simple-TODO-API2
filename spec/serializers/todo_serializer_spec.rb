require 'rails_helper'

RSpec.describe Todo, type: :model do
  describe '#title' do
    it { should validate_presence_of(:title) }
  end

  describe '#text' do
    it { should validate_presence_of(:text) }
  end
end
