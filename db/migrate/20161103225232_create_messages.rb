class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :conversation, null: false
      t.integer :direction, null: false
      t.string  :message, null: false

      t.timestamps null: false
    end
  end
end
