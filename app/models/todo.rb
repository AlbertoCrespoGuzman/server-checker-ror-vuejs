class Todo < ApplicationRecord
  belongs_to :user
  has_many :list_items

  validates :title, presence: true
end
