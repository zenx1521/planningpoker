class AddNumberOfVotingToPokerSession < ActiveRecord::Migration[6.0]
  def up
    add_column :poker_sessions, :number_of_voting, :integer
    PokerSession.reset_column_information
    PokerSession.update_all(:number_of_voting => 1)
  end

  def down
    remove_column :poker_sessions, :number_of_voting
  end
end
