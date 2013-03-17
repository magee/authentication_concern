class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username,        :null => false, :limit => 32
      t.string :email,           :null => false
      t.string :password_digest, :null => false, :limit => 60

      t.timestamps
    end

    add_index :users, :username, :unique => true
    add_index :users, :email, :unique => true
  end
end
