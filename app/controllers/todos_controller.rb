class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update, :destroy]

  def index
    todos = Todo.all
    render json: todos
  rescue
    render json: { errors: [{ title: '不正なリクエストです。', status: 400 }] }, status: :bad_request
  end

  def create
    @todo = Todo.new(todo_params)
    @todo.save!
    render json: @todo, status: :created
  end

  def show
    render json: @todo
  end

  def update
    @todo.update!(todo_params)
    render json: @todo
  end

  def destroy
    @todo.destroy
    render json: @todo
  end

  private

  def todo_params
    params.permit(:title, :text)
  end

  def set_todo
    @todo = Todo.find(params[:id])
  end
end
