include Testable

Fabricator(:queue_item) do
  user
  video
  position { [*1..10].sample }
end
