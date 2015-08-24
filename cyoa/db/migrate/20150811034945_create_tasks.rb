class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer  :user_id,                      null: false
      t.string   :subject,                      null: false
      t.date     :due_date,                     null: false
      t.float    :estimated_completion_hours,   null: false
      t.text     :description,                  null: false

      t.timestamps null: false
    end

    add_index :tasks, :user_id
  end
end
