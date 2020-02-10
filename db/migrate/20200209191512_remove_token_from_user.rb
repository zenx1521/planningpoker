class RemoveTokenFromUser < ActiveRecord::Migration[6.0]
  def change

    remove_column :users, :token, :uuid
  end
end
