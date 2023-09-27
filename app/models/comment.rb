class Comment < ApplicationRecord
  belongs_to :post

  validates :name, :comment, presence: true
end
