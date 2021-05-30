Stage.create!(
  [
    {
      name: 'はじまりのもり',
    },
    {
      name: 'サボタージュさばく'
    },
    {
      name: 'まよいのうみ'
    },
    {
      name: 'ゴロゴロかざん'
    },
    {
      name: 'マンネリけいこく'
    },
    {
      name: 'グータラせつげん'
    },
    {
      name: 'だせいのあれち'
    },
    {
      name: 'あんいつのほらあな'
    },
    {
      name: 'たいだのしろ'
    },
    {
      name: 'はまりぬま'
    },
    {
      name: 'あぶらうりのまち'
    },
    {
      name: 'たいまんのとち'
    },
    {
      name: 'ダラダラひょうざん'
    },
    {
      name: 'おうちゃくやま'
    },
    {
      name: 'ゆうだのとう'
    },
    {
      name: 'めいむ'
    },
    {
      name: 'ものぐさしつげん'
    },
    {
      name: 'ゆうわくのやみ'
    },
    {
      name: 'せいちょうのみち'
    },
    {
      name: '終わりの地'
    },
    {
      name: 'みっかぼうずのやぼう'
    }
  ]
)

User.create!(name: 'ゆうしゃ', password: SecureRandom.urlsafe_base64, email: 'guest@example.com')
guest_user = User.find_by(email: 'guest@example.com')

guest_user.goals.create!(
  [
    {
      goal_status: '体重を10キロへらす',
      category: 'ダイエット',
      deadline: '2021/12/31',
      user_id: guest_user.id,
      level: 50,
      doc_count: 5,
      stage_id: 1
    },
    {
      goal_status: '自力でアプリ開発とデプロイができるようになる',
      category: 'プログラミング',
      deadline: '2021/12/31',
      user_id: guest_user.id,
      level: 90,
      doc_count: 10,
      stage_id: 2
    }
  ]
)

goal = Goal.where(user_id: guest_user.id).first
second_goal = Goal.where(user_id: guest_user.id).second

exercise = ['スクワット', 'うでたて伏せ', '太もものストレッチ', 'せなかのストレッチ', '走りこみ']
count = ['10', '20', '30', '40', '50']
exercise_date = Date.new(2021, 3, 1)
programing = ['HTML', 'CSS', 'Ruby', 'Python', 'Javascript']
time = [*(1..10)]
programing_date = Date.new(2021, 4, 1)

5.times do |i|
  Document.create!(
    [
      {
        body: exercise[rand(4)] + 'を ' + count[rand(5)] + ' 回した！',
        milestone: '明日もうんどうする',
        add_level: 10,
        user_id: guest_user.id,
        goal_id: goal.id,
        created_at: (exercise_date + i),
        updated_at: (exercise_date + i)
      }
    ]
  )
end

10.times do |i|
  Document.create!(
    [
      {
        body: programing[rand(5)] + 'のべんきょうを ' + time[rand(10)].to_s + ' 時間した！',
        milestone: '明日もべんきょうする',
        add_level: 9,
        user_id: guest_user.id,
        goal_id: second_goal.id,
        created_at: (programing_date + i),
        updated_at: (programing_date + i)
      }
    ]
  )
end
