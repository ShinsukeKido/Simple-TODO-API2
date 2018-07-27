require 'rails_helper'

RSpec.describe TodosController, type: :request do
  describe '#index' do
    before { 3.times { create(:todo) } }

    it 'HTTP ステータスコード 200 が返る' do
      get '/todos'
      expect(response.status).to eq 200
    end

    it 'todo が作成された数だけ JSON 形式で返る' do
      get '/todos'
      json = JSON.parse(response.body)
      expect(json.count).to eq 3
    end

    it '返す JSON に、作成した todo の内容が正しく反映されている' do
      get '/todos'
      json = JSON.parse(response.body)
      todo = Todo.order(:created_at).first
      expect(json[0]['id']).to eq todo.id
      expect(json[0]['title']).to eq todo.title
      expect(json[0]['text']).to eq todo.text
      expect(json[0]['created_at']).to eq todo.created_at.as_json
    end
  end

  describe '#create' do
    context '正常' do
      let(:todo_params) { { title: 'title', text: 'text' } }

      it 'HTTP ステータスコード 201 が返る' do
        post '/todos', params: todo_params
        expect(response.status).to eq 201
      end

      it 'todo を新規作成する' do
        expect { post '/todos', params: todo_params }.to change { Todo.count }.by(1)
      end

      it '返す JSON に、作成した todo の内容が正しく反映されている' do
        post '/todos', params: todo_params
        json = JSON.parse(response.body)
        todo = Todo.order(:created_at).first
        expect(json['title']).to eq todo.title
        expect(json['text']).to eq todo.text
      end
    end

    context '異常' do
      let(:todo_params) { { title: 'title' } }

      it 'HTTP ステータスコード 201 が返る' do
        post '/todos', params: todo_params
        expect(response.status).to eq 422
      end

      it 'todo を新規作成する' do
        expect { post '/todos', params: todo_params }.not_to change { Todo.count }
      end

      it '出力される JSON のキーが仕様通りである' do
        post '/todos', params: todo_params
        json = JSON.parse(response.body)
        expected_response = {
          'errors' => [
            {
              'title' => 'バリデーションに失敗しました',
              'status' => 422,
              'source' => { 'pointer' => '/data/attributes/text' },
            },
          ],
        }
        expect(json).to eq expected_response
      end
    end
  end

  describe '#show' do
    context '正常' do
      let(:todo) { create(:todo) }

      it 'HTTP ステータスコード 200 が返る' do
        get "/todos/#{todo.id}"
        expect(response.status).to eq 200
      end

      it '出力される JSON のキーが仕様通りである' do
        get "/todos/#{todo.id}"
        json = JSON.parse(response.body)
        expect(json.keys).to include('id', 'title', 'text', 'created_at')
      end

      it '出力される JSON に、作成した todo の内容が正しく反映されている' do
        get "/todos/#{todo.id}"
        json = JSON.parse(response.body)
        expect(json['id']).to eq todo.id
        expect(json['title']).to eq todo.title
        expect(json['text']).to eq todo.text
        expect(json['created_at']).to eq todo.created_at.as_json
      end
    end

    context '異常' do
      it 'HTTP ステータスコード 200 が返る' do
        get '/todos/hoge'
        expect(response.status).to eq 404
      end

      it '出力される JSON のキーが仕様通りである' do
        get '/todos/hoge'
        json = JSON.parse(response.body)
        expected_response = {
          'errors' => [
            {
              'title' => '見つかりませんでした',
              'status' => 404,
            },
          ],
        }
        expect(json).to eq expected_response
      end
    end
  end

  describe '#update' do
    context '正常' do
      let(:todo) { create(:todo, title: 'before') }
      let(:todo_params) { { title: 'after', text: 'text' } }

      it 'HTTP ステータスコード 200 が返る' do
        put "/todos/#{todo.id}", params: todo_params
        expect(response.status).to eq 200
      end

      it 'todo を更新する' do
        expect { put "/todos/#{todo.id}", params: todo_params }.to change { Todo.find(todo.id).title }.from('before').to('after')
      end

      it '出力される JSON のキーが仕様通りである' do
        put "/todos/#{todo.id}", params: todo_params
        json = JSON.parse(response.body)
        expect(json.keys).to contain_exactly('id', 'title', 'text', 'created_at')
      end

      it '出力される JSON に、更新した todo の内容が正しく反映されている' do
        put "/todos/#{todo.id}", params: todo_params
        json = JSON.parse(response.body)
        expect(json['id']).to eq Todo.first.id
        expect(json['title']).to eq Todo.first.title
        expect(json['text']).to eq Todo.first.text
        expect(json['created_at']).to eq Todo.first.created_at.as_json
      end
    end

    context '異常' do
      let(:todo) { create(:todo, title: 'before') }
      let(:todo_params) { { title: 'after', text: '' } }

      it 'HTTP ステータスコード 200 が返る' do
        put "/todos/#{todo.id}", params: todo_params
        expect(response.status).to eq 422
      end

      it 'todo を更新する' do
        expect { put "/todos/#{todo.id}", params: todo_params }.not_to change { Todo.find(todo.id).title }
      end

      it '出力される JSON のキーが仕様通りである' do
        put "/todos/#{todo.id}", params: todo_params
        json = JSON.parse(response.body)
        expected_response = {
          'errors' => [
            {
              'title' => 'バリデーションに失敗しました',
              'status' => 422,
              'source' => { 'pointer' => '/data/attributes/text' },
            },
          ],
        }
        expect(json).to eq expected_response
      end
    end
  end

  describe '#destroy' do
    context '正常' do
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
        json = JSON.parse(response.body)
        expect(json.keys).to contain_exactly('id', 'title', 'text', 'created_at')
      end

      it '出力される JSON に、削除した todo の内容が正しく反映されている' do
        delete "/todos/#{todo.id}"
        json = JSON.parse(response.body)
        expect(json['id']).to eq todo.id
        expect(json['title']).to eq todo.title
        expect(json['text']).to eq todo.text
        expect(json['created_at']).to eq todo.created_at.as_json
      end
    end

    context '異常' do
      it 'HTTP ステータスコード 404 が返る' do
        delete '/todos/hoge'
        expect(response.status).to eq 404
      end

      it 'todo を削除する' do
        expect { delete '/todos/hoge' }.not_to change { Todo.count }
      end

      it '出力される JSON のキーが仕様通りである' do
        delete '/todos/hoge'
        json = JSON.parse(response.body)
        expected_response = {
          'errors' => [
            {
              'title' => '見つかりませんでした',
              'status' => 404,
            },
          ],
        }
        expect(json).to eq expected_response
      end
    end
  end
end
