class ChangePrivateBoolean < ActiveRecord::Migration
  def up
    Wiki.where(private: nil).update_all(private: false)
    change_column :wikis, :private, :boolean, default: false
  end

  def down
    change_column :wikis, :private, :boolean, default: false
  end
end
