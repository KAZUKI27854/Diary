user = User.find_by(email: 'guest@example.com')

user.goals.create!(
  [
    {
      goal_status: '体重を10キロへらす',
      category: 'ダイエット',
      deadline: '2021/12/31',
      user_id: user.id
    },
    {
      goal_status: '自力でアプリ開発とデプロイができるようになる',
      category: 'プログラミング',
      deadline: '2021/12/31',
      user_id: user.id
    }
  ]
)

goal = Goal.where(user_id: user.id).first
second_goal = Goal.where(user_id: user.id).second

4.times do |i|
  exercise = ['スクワット', 'うでたて伏せ', '太もものストレッチ', 'おなかのストレッチ']
  count = ['10', '20', '30', '40', '50']
  Document.create!(body: exercise[rand(4)] + 'を ' + count[rand(5)] + ' 回した！', milestone: '明日も運動する', add_level: 2, user_id: user.id, goal_id: goal.id, updated_at: (Date.today - i))
  Document.create!(body: 'べんきょうした！', milestone: '明日も勉強する', add_level: 5, user_id: user.id, goal_id: second_goal.id)
end

Stage.create!(
  [
    {
      name: 'ゆうわくのもり',
    },
    {
      name: 'サボタージュさばく'
    }
  ]
)