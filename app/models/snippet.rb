class Snippet < ActiveRecord::Base

  include Searchable

  extend FriendlyId

  friendly_id :title,use:[:slugged,:finders]

  validates :title,presence:true,allow_blank: false
  validates :content,presence:true,allow_blank: false
  validates :category,presence:true
  validates :user,presence:true

  belongs_to :category
  belongs_to :user

  elastic_search_attributes :id,:title,:description,:content
  elastic_search_index :snippet_manager

end


