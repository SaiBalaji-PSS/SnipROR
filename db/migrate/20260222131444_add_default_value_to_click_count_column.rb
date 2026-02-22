class AddDefaultValueToClickCountColumn < ActiveRecord::Migration[8.1]
  def change
    change_column_default :urls, :click_count, 0
  end
end
