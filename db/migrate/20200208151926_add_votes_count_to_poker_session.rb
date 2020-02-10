class AddVotesCountToPokerSession < ActiveRecord::Migration[6.0]


  def up
    add_column :poker_sessions, :votes_count, :integer
    PokerSession.reset_column_information
    PokerSession.update_all(:votes_count => 0)
  end

  def down
    add_column :poker_sessions, :votes_count, :integer
  end
end
