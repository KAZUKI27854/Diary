class ApplicationMailer < ActionMailer::Base
  default from:     "Dot Diary運営 <DotDiary.ambitionofmikkabozu@gmail.com>",
          bcc:      "DotDiary.ambitionofmikkabozu@gmail.com"
  layout 'mailer'
end
