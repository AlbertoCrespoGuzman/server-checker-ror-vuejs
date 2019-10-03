class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, default: '', null: false
      t.string :password_digest

      t.timestamps
    end
  end
end
