class AddLogInCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :log_in_count, :integer
  end
end
