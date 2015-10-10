# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

comedy = Category.create(name: 'Comedy')
crime = Category.create(name: 'Crime')
historical = Category.create(name: 'Historical')

Video.create(title: 'Amadeus', tagline: 'Two pervy 18th-century composers fight, kind of like in Mean Girls but more serious.', small_cover_url: 'amadeus.jpg', large_cover_url: 'amadeus_large.jpg', category: historical))
Video.create(title: 'Monk', tagline: 'This guy always reminds me a little bit of Mr. Bean...', small_cover_url: 'monk.jpg', large_cover_url: 'monk_large.jpg', category: comedy))
Video.create(title: 'Dallas Buyers Club', tagline: 'I hear this one is REALLY good!', small_cover_url: 'dallas_buyers_club.jpg', large_cover_url: 'dallas_buyers_club_large.jpg', category: historical)
Video.create(title: 'Pulp Fiction', tagline: "Let's watch criminals!", small_cover_url: 'pulp_fiction.jpg', large_cover_url: 'pulp_fiction_large.png', category: crime)
