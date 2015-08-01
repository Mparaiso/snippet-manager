class Category < ActiveRecord::Base
  has_many :snippets
  validates :title,presence: true,uniqueness: true

  def self.find_by_id_or_by_title id_or_title
    begin
      @category = Category.find(id_or_title) 
    rescue ActiveRecord::RecordNotFound
      @category = Category.find_by(title:id_or_title)
    end
    return @category
  end

  def to_s
    self.title
  end
end
