include Fakeable

Fabricator(:invitation) do
  name { faker_name }
  email { faker_email }
  inviter { Fabricate :user }
  message { faker_lorem 20 }
end
