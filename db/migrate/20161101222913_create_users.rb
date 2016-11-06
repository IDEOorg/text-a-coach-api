class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :phone_number, null: false
      t.string  :name, null: false
      t.string  :email, null: false
      t.string  :city
      t.string  :state
      t.integer :terms

      t.timestamps null: false
    end
  end
end
