class RemoveVotesCountFromPokerSession < ActiveRecord::Migration[6.0]
  def change

    remove_column :poker_sessions, :votes_count, :integer
  end
end
