require 'rails_helper'

RSpec.describe TodosController, type: :request do
  describe '#index' do
    it 'index.html.erb ページに遷移する' do
      get '/todos'
      expect(response.status).to eq 200
    end
  end

  describe '#create' do
    let(:todo_params) { { title: 'title', text: 'text' } }

    it 'index.html.erb ページに遷移する' do
      binding.pry
      post '/todos',todo_params
      binding.pry
      expect(response.status).to eq 201
    end
  end
end
