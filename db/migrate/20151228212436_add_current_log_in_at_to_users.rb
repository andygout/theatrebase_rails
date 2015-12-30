class AddCurrentLogInAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_log_in_at, :datetime
  end
end
