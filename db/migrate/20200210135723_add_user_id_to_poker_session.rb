class AddUserIdToPokerSession < ActiveRecord::Migration[6.0]
  def change
    add_column :poker_sessions, :user_id, :integer
  end
end
