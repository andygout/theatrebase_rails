class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string      :name
      t.string      :email
      t.string      :password_digest
      t.string      :remember_digest
      t.string      :activation_digest
      t.boolean     :activated
      t.datetime    :activated_at
      t.string      :reset_digest
      t.datetime    :reset_sent_at
      t.datetime    :remember_created_at
      t.datetime    :current_log_in_at
      t.datetime    :last_log_in_at
      t.integer     :log_in_count
      t.timestamps  null: false

      t.references  :creator, index: true
      t.references  :updater, index: true

      t.index       :email, unique: true
    end
    add_foreign_key :users, :users, column: :creator_id
    add_foreign_key :users, :users, column: :updater_id
  end
end
