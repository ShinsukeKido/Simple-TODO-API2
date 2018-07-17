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
      expect(json['id']).to eq Todo.first.id
      expect(json['title']).to eq Todo.first.title
      expect(json['text']).to eq Todo.first.text
      expect(json['created_at']).to eq Todo.first.created_at.as_json
    end
  end

  describe '#show' do
    let(:todo) { create(:todo) }
    let(:json) { JSON.parse(response.body) }

    it 'HTTP ステータスコード 200 が返る' do
      get "/todos/#{todo.id}"
      expect(response.status).to eq 200
    end

    it '出力される JSON のキーが仕様通りである' do
      get "/todos/#{todo.id}"
      expect(json.keys).to eq %w[id title text created_at]
    end

    it '出力される JSON に、作成した todo の内容が正しく反映されている' do
      get "/todos/#{todo.id}"
      expect(json['id']).to eq todo.id
      expect(json['title']).to eq todo.title
      expect(json['text']).to eq todo.text
      expect(json['created_at']).to eq todo.created_at.as_json
    end
  end

  describe '#update' do
    let(:todo) { create(:todo, title: 'before') }
    let(:todo_params) { { title: 'after', text: 'text' } }
    let(:json) { JSON.parse(response.body) }

    it 'HTTP ステータスコード 200 が返る' do
      put "/todos/#{todo.id}", params: todo_params
      expect(response.status).to eq 200
    end

    it 'todo を更新する' do
      expect { put "/todos/#{todo.id}", params: todo_params }.to change { Todo.find(todo.id).title }.from('before').to('after')
    end

    it '出力される JSON のキーが仕様通りである' do
      put "/todos/#{todo.id}", params: todo_params
      expect(json.keys).to eq %w[id title text created_at]
    end

    it '出力される JSON に、更新した todo の内容が正しく反映されている' do
      put "/todos/#{todo.id}", params: todo_params
      expect(json['id']).to eq Todo.first.id
      expect(json['title']).to eq Todo.first.title
      expect(json['text']).to eq Todo.first.text
      expect(json['created_at']).to eq Todo.first.created_at.as_json
    end
  end

  describe '#destroy' do
    let(:json) { JSON.parse(response.body) }
    let!(:todo) { create(:todo) }

    it 'HTTP ステータスコード 200 が返る' do
      delete "/todos/#{todo.id}"
      expect(response.status).to eq 200
    end

    it 'todo を削除する' do
      expect { delete "/todos/#{todo.id}" }.to change { Todo.count }.by(-1)
    end

    it '出力される JSON のキーが仕様通りである' do
      delete "/todos/#{todo.id}"
      expect(json.keys).to eq %w[id title text created_at]
    end

    it '出力される JSON に、削除した todo の内容が正しく反映されている' do
      delete "/todos/#{todo.id}"
      expect(json['id']).to eq todo.id
      expect(json['title']).to eq todo.title
      expect(json['text']).to eq todo.text
      expect(json['created_at']).to eq todo.created_at.as_json
    end
  end
end
