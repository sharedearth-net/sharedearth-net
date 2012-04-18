class RemoveEntityTypeTable < ActiveRecord::Migration
  def self.up
    drop_table :entity_types
  end

  def self.down
    create_table :entity_types do |t|
      t.string :entity_type_name

      t.timestamps
    end

    # not initialising table but having following hash as reference
    """
    entity_types = [
                      {:id => 1, :name => 'Person'},
                      {:id => 2, :name => 'Item'},
                      {:id => 3, :name => 'Skill'},
                      {:id => 4, :name => 'Village'},
                      {:id => 5, :name => 'Community'},
                      {:id => 6, :name => 'Project'},
                      {:id => 7, :name => 'Trusted Person'},
                      {:id => 8, :name => 'Mutual Person'}
                    ]
    """
  end
end
