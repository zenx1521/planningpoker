class AddUserIdToVote < ActiveRecord::Migration[6.0]
  def change
    add_column :votes, :user_id, :integer
  end
end
