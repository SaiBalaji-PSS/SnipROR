class AddThumbnailImageToUrls < ActiveRecord::Migration[8.1]
  def change
    add_column :urls, :thumnailimage, :string
  end
end
