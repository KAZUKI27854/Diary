FactoryBot.define do
  factory :goal do
    association :stage
    association :user

    goal_status { Faker::Games::Pokemon.move }
    category { Faker::Games::Pokemon.move }
    deadline { Faker::Date.in_date_period }
    doc_count { 1 }
  end
end