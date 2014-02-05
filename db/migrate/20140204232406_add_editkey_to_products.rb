class AddEditkeyToProducts < ActiveRecord::Migration
  def change
    add_column :products, :editkey, :string
  end
end
