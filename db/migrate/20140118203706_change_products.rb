class ChangeProducts < ActiveRecord::Migration
  def change
    remove_column :products, :publisher, :string
    remove_column :products, :pages, :integer
    add_column :products, :fprice, :string
  end
end
