class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.references :platform, null: false
      t.references :agent, null: false
      t.references :user, null: false
      t.string :summary_question
      t.string :summary_answer
      t.datetime :last_message_at

      t.timestamps null: false
    end
  end
end
