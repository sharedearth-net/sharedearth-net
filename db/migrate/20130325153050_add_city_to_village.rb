class AddCityToVillage < ActiveRecord::Migration
  def change
    add_column :villages, :city, :string
  end
end
