class CreateGameIdeas < ActiveRecord::Migration
  def change
    create_table :game_ideas do |t|
      t.string :word
      t.string :mode

      t.timestamps
    end
  end
end
