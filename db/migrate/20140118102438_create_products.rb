class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :isbn
      t.string :title
      t.string :author
      t.string :publisher
      t.integer :pages
      t.integer :price
      t.integer :category_id
      t.string :amazon_url
      t.string :small_image_url
      t.string :medium_image_url

      t.timestamps
    end
  end
end
