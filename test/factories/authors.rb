FactoryBot.define do
  factory :author do
    name { "MyString" }
    lastname { "MyString" }
    sequence(:email) { |n| "user#{n}@test.com" }
    city { "MyString" }
    birth_date { Date.today }
  end
end
