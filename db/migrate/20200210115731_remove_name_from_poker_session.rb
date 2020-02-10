class RemoveNameFromPokerSession < ActiveRecord::Migration[6.0]
  def change

    remove_column :poker_sessions, :name, :string
  end
end
