def open_seed_image(image_file)
  File.open(File.join(Rails.root, "public/tmp/#{image_file}"))
end

comedy = Fabricate :category, name: 'Comedy'
crime = Fabricate :category, name: 'Crime'
historical = Fabricate :category, name: 'Historical'

amadeus = Video.create!(title: 'Amadeus',
  tagline: 'Two pervy 18th-century composers fight, kind of like in Mean Girls, but with more men in wigs.',
  small_cover: open_seed_image('amadeus.jpg'),
  large_cover: open_seed_image('amadeus_large.jpg'),
  category: historical)

Video.create(title: 'Monk',
  tagline: 'This guy always reminds me a little bit of Mr. Bean...', small_cover: open_seed_image('monk.jpg'),
  large_cover: open_seed_image('monk_large.jpg'),
  category: comedy)

Video.create!(title: 'Dallas Buyers Club',
  tagline: 'I hear this one is really good!',
  small_cover: open_seed_image('dallas_buyers_club.jpg'),
  large_cover: open_seed_image('dallas_buyers_club_large.jpg'),
  category: historical)

Video.create(title: 'Pulp Fiction',
  tagline: "Let's watch criminals.",
  small_cover: open_seed_image('pulp_fiction.jpg'),
  large_cover: open_seed_image('pulp_fiction_large.png'),
  category: crime)

Video.create(title: 'South Park',
  tagline: "Simpson's did it!",
  small_cover: open_seed_image('south_park.jpg'),
  large_cover: open_seed_image('south_park_large.jpg'),
  category: comedy)

Video.create(title: 'The Office',
  tagline: "Bears, Beets, Battlestar Galactica.",
  small_cover: open_seed_image('the_office.jpg'),
  large_cover: open_seed_image('the_office_large.jpg'),
  category: comedy)

Video.create(title: 'Portlandia',
  tagline: "Put a bird on it!",
  small_cover: open_seed_image('portlandia.jpg'),
  large_cover: open_seed_image('portlandia_large.jpg'),
  category: comedy)

Video.create(title: 'Parks and Recreation',
  tagline: "This show was funny sometimes.",
  small_cover: open_seed_image('parks_and_rec.jpg'),
  large_cover: open_seed_image('parks_and_rec_large.jpg'),
  category: comedy)

Video.create(title: 'Futurama',
  tagline: "I don't know any quotes from this one, but it's good.",
  small_cover: open_seed_image('futurama.jpg'),
  large_cover: open_seed_image('futurama_large.jpg'),
  category: comedy)

Video.create(title: 'Family Guy',
  tagline: "Remember that time I...hehehehehehehehehehe",
  small_cover: open_seed_image('family_guy.jpg'),
  large_cover: open_seed_image('family_guy_large.jpg'),
  category: comedy)

5.times do |count|
  user = Fabricate :user, email: "user#{count}@email.com"
  Fabricate :review, video: amadeus, user: user
  1.times do |times|
    Fabricate :queue_item, video: Video.all.sample, user: user, position: times + 1
  end
end
