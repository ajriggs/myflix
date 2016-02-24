include Fakeable

Fabricator(:user) do
  full_name { faker_name }
  email { faker_email }
  password { 'testpass' }
end
