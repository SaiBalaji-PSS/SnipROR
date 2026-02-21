class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :user_id
      t.string :user_name
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
