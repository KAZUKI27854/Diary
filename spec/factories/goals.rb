FactoryBot.define do
  factory :goal do
    goal_status { Faker::Games::Pokemon.move }
    category { Faker::Games::Pokemon.move }
    deadline { Faker::Date.in_date_period }
  end
end