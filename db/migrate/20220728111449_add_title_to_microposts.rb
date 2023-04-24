class AddTitleToMicroposts < ActiveRecord::Migration[7.0]
  def change
    add_column :microposts, :title, :string
  end
end
