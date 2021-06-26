# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
require 'active_support/core_ext/time'
def jst(time)
  Time.zone = 'Asia/Tokyo'
  Time.zone.parse(time).localtime($system_utc_offset)
end

require File.expand_path(File.dirname(__FILE__) + "/environment")
set :environment, :production
set :output, 'log/cron.log'
every :day, at: jst('09:00 am') do
  begin
    runner "Batch::DataReset.data_reset"
    rake "db:seed:guest_user"
  rescue => e
    Rails.logger.error("aborted rails runner")
    raise e
  end
end