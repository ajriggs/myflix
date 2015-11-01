# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

comedy = Fabricate :category, name: 'Comedy'
crime = Fabricate :category, name: 'Crime'
historical = Fabricate :category, name: 'Historical'

amadeus = Video.create(title: 'Amadeus', tagline: 'Two pervy 18th-century composers fight, kind of like in Mean Girls, but with more men in wigs.', small_cover_url: 'amadeus.jpg', large_cover_url: 'amadeus_large.jpg', category: historical)
Video.create(title: 'Monk', tagline: 'This guy always reminds me a little bit of Mr. Bean...', small_cover_url: 'monk.jpg', large_cover_url: 'monk_large.jpg', category: comedy)
Video.create(title: 'Dallas Buyers Club', tagline: 'I hear this one is REALLY good!', small_cover_url: 'dallas_buyers_club.jpg', large_cover_url: 'dallas_buyers_club_large.jpg', category: historical)
Video.create(title: 'Pulp Fiction', tagline: "Let's watch criminals!", small_cover_url: 'pulp_fiction.jpg', large_cover_url: 'pulp_fiction_large.png', category: crime)
Video.create(title: 'South Park', tagline: "Simpson's did it!", small_cover_url: 'south_park.jpg', large_cover_url: 'south_park_large.jpg', category: comedy)
Video.create(title: 'The Office', tagline: "Bears, Beets, Battlestar Galactica.", small_cover_url: 'the_office.jpg', large_cover_url: 'the_office_large.jpg', category: comedy)
Video.create(title: 'Portlandia', tagline: "Put a bird on it!", small_cover_url: 'portlandia.jpg', large_cover_url: 'portlandia_large.jpg', category: comedy)
Video.create(title: 'Parks and Recreation', tagline: "This show was funny sometimes.", small_cover_url: 'parks_and_rec.jpg', large_cover_url: 'parks_and_rec_large.jpg', category: comedy)
Video.create(title: 'Futurama', tagline: "I don't know any quotes from this one, but it's good.", small_cover_url: 'futurama.jpg', large_cover_url: 'futurama_large.jpg', category: comedy)
Video.create(title: 'Family Guy', tagline: "Remember that time I...hehehehehehehehehehe", small_cover_url: 'family_guy.jpg', large_cover_url: 'family_guy_large.jpg', category: comedy)

5.times do |count|
  user = Fabricate :user, email: "user#{count}@email.com"
  Fabricate :review, video: amadeus, user: user
  2.times do |times|
    Fabricate :queue_item, video: Video.all.sample, user: user, position: times + 1
  end
end
