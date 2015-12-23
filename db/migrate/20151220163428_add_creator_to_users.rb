class AddCreatorToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :creator, references: :users, index: true
    add_foreign_key :users, :users, column: :creator_id
  end
end
