require 'rails_helper'

RSpec.describe TodosController, type: :request do
  describe '#index' do
    let(:jsons) { JSON.parse(response.body) }

    before { 3.times { create(:todo) } }

    it 'HTTP ステータスコード 200 が返る' do
      get '/todos'
      expect(response.status).to eq 200
    end

    it 'todo が作成された数だけ JSON 出力される' do
      get '/todos'
      expect(jsons.count).to eq 3
    end

    it '出力される JSON のキーが仕様通りである' do
      get '/todos'
      expect(jsons[0].keys).to eq %w[id title text created_at]
    end

    it '出力される JSON に、作成した todo の内容が正しく反映されている' do
      get '/todos'
      expect(jsons[0]['id']).to eq Todo.order(:created_at).first.id
      expect(jsons[0]['title']).to eq Todo.order(:created_at).first.title
      expect(jsons[0]['text']).to eq Todo.order(:created_at).first.text
      expect(jsons[0]['created_at']).to eq Todo.order(:created_at).first.created_at.as_json
    end
  end

  describe '#create' do
    let(:todo_params) { { title: 'title', text: 'text' } }
    let(:json) { JSON.parse(response.body) }

    it 'HTTP ステータスコード 201 が返る' do
      post '/todos', params: todo_params
      expect(response.status).to eq 201
    end

    it 'todo を新規作成する' do
      expect { post '/todos', params: todo_params }.to change { Todo.count }.by(1)
    end

    it '出力される JSON のキーが仕様通りである' do
      post '/todos', params: todo_params
      expect(json.keys).to eq %w[id title text created_at]
    end

    it '出力される JSON に、作成した todo の内容が正しく反映されている' do
      post '/todos', params: todo_params
      expect(json.keys).to eq %w[id title text created_at]
      expect(json['id']).to eq Todo.first.id
      expect(json['title']).to eq Todo.first.title
      expect(json['text']).to eq Todo.first.text
      expect(json['created_at']).to eq Todo.first.created_at.as_json
    end
  end
end
