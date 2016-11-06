class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :name, null: false
      t.string :job_title, null: false
      t.string :email, null: false

      t.timestamps null: false
    end
  end
end
