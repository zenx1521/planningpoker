class CreatePokerSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :poker_sessions do |t|
      t.text :description
      t.string :name

      t.timestamps
    end
  end
end
