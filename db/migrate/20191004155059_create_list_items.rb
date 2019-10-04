class CreateListItems < ActiveRecord::Migration[6.0]
  def change
    create_table :list_items do |t|
      t.string :name
      t.string :status
      t.string :url_base
      t.string :url_endpoint
      t.string :code
      t.integer :requests, default: 0
      t.integer :thrown_errors, default: 0
      t.belongs_to :todo
      t.timestamps
    end
  end
end
