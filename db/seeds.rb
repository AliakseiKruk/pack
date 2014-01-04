# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Product.create(name:'Small', width:1, height:1, depth:1, weight:1, stock_level:11)
Product.create(name:'Medium', width:3, height:1, depth:1, weight:3, stock_level:11)
Product.create(name:'Large', width:8, height:1, depth:1, weight:8, stock_level:11)
Box.create(name:'Small', volume:3)
Box.create(name:'Medium', volume:5)
Box.create(name:'Large', volume:10)
