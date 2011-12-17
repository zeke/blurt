class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :word
      t.string :mode
      t.datetime :completed_at

      t.timestamps
    end
  end
end
