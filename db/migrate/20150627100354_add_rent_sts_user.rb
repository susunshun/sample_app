class AddRentStsUser < ActiveRecord::Migration
  def change
  	add_column :users, :rentsts, :Integer, default: nil
  end
end
