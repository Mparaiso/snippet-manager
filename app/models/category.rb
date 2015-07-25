class Category < ActiveRecord::Base
  has_many :snippets
  validates :name,presence: true,uniqueness: true
end
