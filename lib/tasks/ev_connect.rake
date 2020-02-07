desc "This task is called on a schedule to check station statuses"

task :check_stations => :environment do
  time = Time.now.in_time_zone('Pacific Time (US & Canada)')

  week_day = time.wday
  hour = time.hour

  return unless (1..5).include?(week_day)
  return unless (8..17).include?(hour)

  Evacancy::EvConnectService.check_stations
end
