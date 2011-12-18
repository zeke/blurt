class RenameGameCompleteAtToOverAt < ActiveRecord::Migration
  def up
    rename_column :games, :completed_at, :over_at
  end

  def down
    rename_column :games, :over_at, :completed_at
  end
end
