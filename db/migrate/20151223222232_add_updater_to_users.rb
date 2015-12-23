class AddUpdaterToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :updater, references: :users, index: true
    add_foreign_key :users, :users, column: :updater_id
  end
end
