class TodosController < ApplicationController
  def index
    @todos = Todo.all
    render json: @todos
  rescue
    render json: { errors: [{ title: '不正なリクエストです。', status: 400 }] }, status: :bad_request
  end

  def create
    @todo = Todo.new(todo_params)
    @todo.save!
    render json: @todo, status: :created
  end

  def show
    @todo = Todo.find(params[:id])
    render json: @todo
  end

  def update
    @todo = Todo.find(params[:id])
    @todo.update!(todo_params)
    render json: @todo
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy
    render json: @todo
  end

  private

  def todo_params
    params.permit(:title, :text)
  end
end
