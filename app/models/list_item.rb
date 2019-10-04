class ListItem < ApplicationRecord
    validates :name, :url_base, :url_endpoint, presence: true
    belongs_to :todo
end 