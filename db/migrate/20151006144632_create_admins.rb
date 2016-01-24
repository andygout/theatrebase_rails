class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins, id: false do |t|
      t.belongs_to :user, index: true, foreign_key: true, unique: true

      t.datetime :created_at

      t.belongs_to :assignor, index: true
    end
    add_foreign_key :admins, :users, column: :assignor_id
  end
end
