include Testable

Fabricator(:video) do
  category
  title { faker_lorem 5 }
  tagline { "Starring the acclaimed #{faker_name}" }
end
