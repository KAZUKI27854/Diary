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

    #検索テストで使用
    trait :list_1 do
      body { '1つ目のTodoリスト' }
    end

    trait :list_2 do
      body { '2つ目のTodoリスト' }
    end

    trait :list_3 do
      body { '3つ目のTodoリスト' }
    end

    trait :list_4 do
      body { '11月10日までに課題提出' }
    end
  end
end