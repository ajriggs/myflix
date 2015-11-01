include Testable

Fabricator(:review) do
  rating { [*1..5].sample }
  review { faker_lorem 50 }
end
