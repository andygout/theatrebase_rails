class CreateSuperAdmins < ActiveRecord::Migration
  def change
    create_table :super_admins do |t|
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
