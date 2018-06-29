class TodosController < ApplicationController
  def index
    @todos = Todo.all
    render json: @todos
  end

  def create
    binding.pry
    todo_params = JSON.parse(request.body.read, {:symbolize_names => true})
    @todo = Todo.new(todo_params)
    @todo.save
    render json: @todo
  end

  private

  # def todo_params
  #   JSON.parse(request.body.read)
  # end
end
