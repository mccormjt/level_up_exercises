class CreateRecipients < ActiveRecord::Migration
  def change
    create_table :recipients do |t|
      t.string  :name,         null: false, default: ""
      t.string  :phone_number, null: false, default: ""
      t.integer :user_id,      null: false

      t.timestamps
    end

    add_index :recipients, [:user_id, :phone_number], unique: true
  end
end
