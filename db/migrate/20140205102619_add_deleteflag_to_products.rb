class AddDeleteflagToProducts < ActiveRecord::Migration
  def change
    add_column :products, :deleteflag, :integer
  end
end
