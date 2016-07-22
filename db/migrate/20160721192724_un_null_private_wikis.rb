class UnNullPrivateWikis < ActiveRecord::Migration
  def up
    Wiki.where(private: nil).update_all(private: false)
    change_column :wikis, :private, :boolean, null: false
  end

  def down
    change_column :wikis, :private, :boolean, null: true
  end
end
