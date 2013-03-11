class ChangeEntityTypeToSpecificEntityTypeInHumanNetwork < ActiveRecord::Migration
  def change
  	rename_column :human_networks, :entity_type, :specific_entity_type
  end
end
