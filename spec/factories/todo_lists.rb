FactoryBot.define do
  factory :todo_list do
    body { Faker::Games::Zelda.game }
    deadline { Faker::Date.in_date_period }
  end
end