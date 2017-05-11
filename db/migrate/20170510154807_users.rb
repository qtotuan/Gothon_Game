class Users < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, :email, :password
    end
  end
end
