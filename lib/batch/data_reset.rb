class Batch::DataReset
  def self.data_reset
    guest_user = User.find_by(email: 'guest@example.com')
    guest_user.destroy

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
          stage_id: 1,
        },
        {
          goal_status: '自力でアプリ開発とデプロイをする',
          category: 'プログラミング',
          deadline: Date.current + 2,
          user_id: guest_user.id,
          level: 90,
          doc_count: 10,
          stage_id: 2,
        },
      ]
    )

    goal = guest_user.goals.first
    second_goal = guest_user.goals.second

    exercise = ['スクワット', 'うでたて伏せ', '太もものストレッチ', 'せなかのストレッチ', '走りこみ']
    count = ['10', '20', '30', '40', '50']
    exercise_date = Date.current - 7
    programing = ['HTML', 'CSS', 'Ruby', 'Python', 'Javascript']
    time = [*(1..10)]
    programing_date = Date.current - 12

    5.times do |i|
      Document.create!(
        [
          {
            body: exercise[rand(5)] + 'を ' + count[rand(5)] + ' 回した！',
            milestone: '明日もうんどうする',
            add_level: 10,
            user_id: guest_user.id,
            goal_id: goal.id,
            created_at: (exercise_date + i),
            updated_at: (exercise_date + i),
          },
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
            updated_at: (programing_date + i),
          },
        ]
      )
    end

    3.times do |i|
      TodoList.create!(
        [
          {
            user_id: guest_user.id,
            goal_id: second_goal.id,
            body: programing[i] + 'の課題を提出する',
            deadline: Date.new(2021, 9, 1),
            priority: 0,
          },
        ]
      )
    end

    2.times do |i|
      TodoList.create!(
        [
          {
            user_id: guest_user.id,
            goal_id: goal.id,
            body: exercise[i] + 'を週1回以上する',
            priority: 1,
          },
        ]
      )
    end

    TodoList.create!(
      [
        {
          user_id: guest_user.id,
          goal_id: second_goal.id,
          body: 'プログラミングの本を2冊読む',
          deadline: Date.current + 2,
          priority: 0,
        },
        {
          user_id: guest_user.id,
          goal_id: second_goal.id,
          body: 'Javascriptを使った機能を3つ自作する',
          deadline: Date.new(2021, 9, 1),
          is_finished: true,
          priority: 2,
        },
      ]
    )

  end
end