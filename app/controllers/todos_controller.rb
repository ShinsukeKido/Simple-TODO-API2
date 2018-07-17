class TodosController < ApplicationController
  def index
    @todos = Todo.all
    render json: @todos
  end

  def create
    @todo = Todo.new(todo_params)
    @todo.save
    render json: @todo, status: :created
  end

  def show
    @todo = Todo.find(params[:id])
    render json: @todo
  end

  private

  def todo_params
    params.permit(:title, :text)
  end
end
