class AddDefaultValueToVotesCount < ActiveRecord::Migration[6.0]
  def up
    change_column_default :poker_sessions, :votes_count, 0
  end

  def down 
    change_column_default :poker_sessions, :votes_count, nil
  end
end
