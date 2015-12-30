class AddLastLogInAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_log_in_at, :datetime
  end
end
