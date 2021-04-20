FactoryBot.define do
  factory :document do
    body { Faker::Games::Zelda.game }
    milestone { Faker::Games::Zelda.location }
    add_level { Faker::Number.non_zero_digit }
  end
end