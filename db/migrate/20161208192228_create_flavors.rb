class CreateFlavors < ActiveRecord::Migration
  def change
    create_table :flavors do |t|
      t.string :name, null:false

      t.timestamps null: false
    end

    add_reference :conversations, :flavor

    Platform.all.each do |p|
      Flavor.create(
        id: p.id,
        name: p.name
      )
    end

    Conversation.all.each do |c|
      c.update_attribute :flavor_id, c.platform_id
    end
  end
end
