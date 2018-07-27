require 'rails_helper'

RSpec.describe TodoSerializer, type: :serializer do
  let(:attributes) { described_class.new(todo).attributes }
  let(:todo) { create(:todo) }

  it '返す JSON の id に、作成した todo の id が正しく反映されている' do
    expect(attributes[:id]).to eq todo.id
  end

  it '返す JSON の title に、作成した todo の title が正しく反映されている' do
    expect(attributes[:title]).to eq todo.title
  end

  it '返す JSON の text に、作成した todo の text が正しく反映されている' do
    expect(attributes[:text]).to eq todo.text
  end

  it '返す JSON の created_at に、作成した todo の created_at が正しく反映されている' do
    expect(attributes[:created_at]).to eq todo.created_at
  end

  it '返す JSON のキーが、仕様通りであること' do
    expect(attributes.keys).to contain_exactly(:id, :title, :text, :created_at)
  end
end
