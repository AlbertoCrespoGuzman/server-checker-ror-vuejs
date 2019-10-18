class AddFcmTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :fcm_token, :string, default: ''
  end
end
