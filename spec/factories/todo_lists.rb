FactoryBot.define do
  factory :todo_list do

    body { Faker::Games::Zelda.game }
    priority { 1 }

    trait :with_deadline do
      deadline { Faker::Date.in_date_period }
      priority { 0 }
    end

    trait :finished do
       priority { 2 }
    end
  end
end