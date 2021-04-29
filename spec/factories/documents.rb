FactoryBot.define do
  factory :document do
    body { Faker::Games::Zelda.game }
    milestone { Faker::Games::Zelda.location }
    add_level { 1 }
  end
end