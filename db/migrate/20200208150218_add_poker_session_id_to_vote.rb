class AddPokerSessionIdToVote < ActiveRecord::Migration[6.0]
  def change
    add_column :votes, :poker_session_id, :integer
  end
end
