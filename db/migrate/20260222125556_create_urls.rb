class CreateUrls < ActiveRecord::Migration[8.1]
  def change
    create_table :urls do |t|
      t.string :url
      t.string :short_code
      t.integer :click_count
      t.string :user_id

      t.timestamps
    end
  end
end
