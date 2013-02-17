class AddRatingToItems < ActiveRecord::Migration
  def change
    add_column :items, :average_rating, :integer
    add_column :items, :number_of_times_rated, :integer
  end
end
