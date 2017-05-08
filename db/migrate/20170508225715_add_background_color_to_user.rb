class AddBackgroundColorToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :background_color, :string, default: "51A0AF"
  end
end
