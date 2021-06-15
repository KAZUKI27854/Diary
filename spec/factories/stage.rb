FactoryBot.define do
  factory :stage do
    name { Faker::Games::Zelda.location }
  end
end