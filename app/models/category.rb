class Category < ActiveRecord::Base
  
  extend FriendlyId

  friendly_id :title,use: [:slugged,:finders]

  has_many :snippets
  validates :title,presence: true,uniqueness: true

  def to_s
    self.title
  end
end
