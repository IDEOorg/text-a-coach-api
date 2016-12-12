class AddHandleToFlavor < ActiveRecord::Migration
  def change
    add_column :flavors, :handle, :string
  end
end
