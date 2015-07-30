class Category < ActiveRecord::Base
  has_many :snippets
  validates :title,presence: true,uniqueness: true
end
