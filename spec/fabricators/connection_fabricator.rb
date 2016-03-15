include Fakeable

Fabricator(:connection) do
  guide { Fabricate :user }
  follower { Fabricate :user }
end
