class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.integer  :state,          null: false, default: 0
      t.integer  :assignment_id,  null: false
      t.text     :message

      t.timestamps null: false
    end

    add_index :statuses, :assignment_id
  end
end
