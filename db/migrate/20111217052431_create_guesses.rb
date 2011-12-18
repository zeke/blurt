class CreateGuesses < ActiveRecord::Migration
  def change
    create_table :guesses do |t|
      t.integer :game_id
      t.integer :user_id
      t.string :word
      t.datetime :vouched_at

      t.timestamps
    end
  end
end
