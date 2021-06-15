FactoryBot.define do
  factory :todo_list do
    association :goal
    user { goal.user }

    body { Faker::Games::Zelda.game }
    priority { 1 }

    #チェックアクションのテストで使用
    trait :with_deadline do
      deadline { Faker::Date.in_date_period }
      priority { 0 }
    end

    trait :finished do
      priority { 2 }
      is_finished { true }
    end
  end
end