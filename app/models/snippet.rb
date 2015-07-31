class Snippet < ActiveRecord::Base
  validates :title,presence:true,allow_blank: false
  validates :content,presence:true,allow_blank: false
  validates :category,presence:true
  validates :user,presence:true
  belongs_to :category
  belongs_to :user
end
