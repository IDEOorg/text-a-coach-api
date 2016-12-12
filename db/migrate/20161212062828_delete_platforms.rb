class DeletePlatforms < ActiveRecord::Migration
  def up
  	remove_reference(:conversations, :platform, index: true)

  	drop_table :platforms
  end

  def down
  	raise "Irreversible migration"
  end
end
