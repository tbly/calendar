class RemoveOfficerFromArrests < ActiveRecord::Migration
  def up
    remove_column :arrests, :officer
  end

  def down
    add_column :arrests, :officer, :string
  end
end
