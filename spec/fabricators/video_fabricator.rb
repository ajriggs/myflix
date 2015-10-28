Fabricator(:video) do
  category(name: 'Latin Horror')
  title { Faker::Lorem.words(6).join(' ') }
  tagline { "Starring the acclaimed #{Faker::Name.name}" }
end
