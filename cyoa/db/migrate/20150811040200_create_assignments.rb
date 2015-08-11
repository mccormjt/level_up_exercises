class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :task_id,       null: false
      t.integer :recipient_id,  null: false

      t.timestamps null: false
    end

    add_index :assignments, [:task_id, :recipient_id], unique: true
  end
end
