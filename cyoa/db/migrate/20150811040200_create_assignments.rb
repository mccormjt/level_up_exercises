class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer  :task_id,       null: false
      t.integer  :recipient_id,  null: false
      t.integer  :guid,          null: false
      t.boolean  :archived, default: false, null: false
      t.float    :followup_hours

      t.timestamps null: false
    end

    add_index :assignments, [:task_id, :recipient_id], unique: true
    add_index :assignments, [:recipient_id, :guid], unique: true
    add_index :assignments, :archived
  end
end
