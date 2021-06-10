class Batch::DataReset
  def self.data_reset
    guest_user = User.find_by(email: 'guest@example.com')
    guest_user.goals.delete_all

    guest_user.goals.create(
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
      Document.create(
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

    5.times do |i|
      Document.create(
        [
          {
            body: programing[rand(5)] + 'のべんきょうを ' + time[rand(10)].to_s + ' 時間した！',
            milestone: '明日もべんきょうする',
            add_level: time[rand(10)],
            user_id: guest_user.id,
            goal_id: second_goal.id,
            created_at: (programing_date + i),
            updated_at: (programing_date + i)
          }
        ]
      )
    end
  end
end