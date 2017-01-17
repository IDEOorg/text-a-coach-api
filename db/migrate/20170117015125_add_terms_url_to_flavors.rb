class AddTermsUrlToFlavors < ActiveRecord::Migration
  def change
    add_column :flavors, :terms_url, :string
  end
end
