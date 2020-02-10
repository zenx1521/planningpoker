class AddFinishedToPokerSession < ActiveRecord::Migration[6.0]
  def up
    add_column :poker_sessions, :finished, :boolean, default: false
    PokerSession.reset_column_information
    PokerSession.update_all(:finished => false)
  end
  
  def down
    add_column :poker_sessions, :finished, :boolean, default: nil
  end
end
