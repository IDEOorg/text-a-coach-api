class CreateSmoochUsers < ActiveRecord::Migration
  def change
    create_table :smooch_users do |t|
      t.references :flavor
      t.string :phone_number, index: true
      t.string :smooch_id, index: true
      t.datetime :seen_at

      t.timestamps null: false
    end
  end
end
