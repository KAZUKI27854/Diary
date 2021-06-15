FactoryBot.define do
  factory :document do
    association :goal
    user { goal.user }

    body { Faker::Games::Zelda.game }
    milestone { Faker::Games::Zelda.location }
    add_level { 1 }

    #検索テストの際に使用
    trait :doc_1 do
      body { '1つ目のドキュメント' }
    end

    trait :doc_2 do
      body { '2つ目のドキュメント' }
    end

    trait :doc_3 do
      body { '3つ目のドキュメント' }
    end

    trait :doc_4 do
      body { '1時間運動した' }
    end
  end
end