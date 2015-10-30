Fabricator(:video) do
  category(name: 'Latin Horror')
  title { faker_lorem 6 }
  tagline { "Starring the acclaimed #{Faker::Name.name}" }
end
