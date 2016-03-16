include Fakeable

Fabricator(:follow) do
  guide { Fabricate :user }
  follower { Fabricate :user }
end
