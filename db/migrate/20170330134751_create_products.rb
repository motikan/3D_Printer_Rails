class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.string :image
      t.string :editkey
      t.boolean :deleteflag, default: 0
      t.timestamps null: false
    end
  end
end
