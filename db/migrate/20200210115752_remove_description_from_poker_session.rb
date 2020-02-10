class RemoveDescriptionFromPokerSession < ActiveRecord::Migration[6.0]
  def change

    remove_column :poker_sessions, :description, :string
  end
end
