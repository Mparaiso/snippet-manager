# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
password = SecureRandom.urlsafe_base64(20)
anonymous = User.create!(nickname:'anonymous',email:'anonymous@example.com',
                         password:password,password_confirmation:password)

categories = JSON.load(File.open('./db/dump.json')).map { |category|
  Category.create!(title:category['title'],description:category['description'],
                   id:category['id'])
}

snippets = JSON.load(File.open('./db/snippets_dump.json')).map { |snippet| 
  Snippet.create!(id:snippet['id'],title:snippet['title'],description:snippet['description'],
                  content:snippet['content'],category_id:snippet['category_id'],
                  user:anonymous)
}



