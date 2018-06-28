class CreateTodos < ActiveRecord::Migration[5.2]
  def change
    create_table :todos, id: :uuid do |t|
      t.string :title
      t.string :text

      t.timestamps
    end
  end
end
