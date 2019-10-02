class Scheduler

  TRAVEL_TIME = 0.5
  DAY_START = 9.0
  DAY_LENGTH = 8.0

  def self.schedule(proposed_meetings)
    # Schedule offsites first, to utilize start of day travel, and overlapping travel.
    proposed_meetings.sort_by!{ |m| m[:type] }

    calculate(proposed_meetings)
  end

  private

  def self.calculate(proposed_meetings)
    time_in_meetings, schedule = arranged_schedule(proposed_meetings)
    all_offsites = proposed_meetings.select{|m|m[:type] == :onsite}.length == 0
    valid = valid_day?(time_in_meetings, all_offsites)

    valid ? accept(schedule) : decline
  end

  def self.accept(s)
    p "The proposed set of meetings can be scheduled as follows:"
    s.each do |item|
      p item
    end
  end

  def self.decline
    p "The proposed set of meetings would run past 8 hours."
  end

  def self.valid_day?(time_in_meetings, all_offsites)
    time_in_meetings -= 0.5 if all_offsites # First and last 30 minutes are free if we're never onsite!
    time_in_meetings <= 8
  end

  def self.arranged_schedule(proposed_meetings)
    schedule = []
    time_in_meetings = 0
    proposed_meetings.each do |meeting|
      meeting_start = float_to_time(time_in_meetings + DAY_START)
      meeting_end = float_to_time(time_in_meetings + DAY_START + meeting[:duration])
      schedule << "#{meeting_start}-#{(meeting_end)}: #{meeting[:name]}"
      time_in_meetings += meeting[:duration]
      time_in_meetings += TRAVEL_TIME if meeting[:type] == :offsite
    end
    return time_in_meetings, schedule
  end

  def self.float_to_time(fl)
    sec = (fl * 3600).to_i
    min, sec = sec.divmod(60)
    hour, min = min.divmod(60)
    "%02d:%02d" % [hour, min]
  end
end


day1 =
  [
    { name: "Meeting 1", duration: 1.5, type: :onsite },
    { name: "Meeting 2", duration: 2, type: :offsite },
    { name: "Meeting 3", duration: 1, type: :onsite },
    { name: "Meeting 4", duration: 1, type: :offsite },
    { name: "Meeting 5", duration: 1, type: :offsite },
]

day2 = [
  { name: "Meeting 1", duration: 0.5, type: :offsite },
  { name: "Meeting 2", duration: 0.5, type: :onsite },
  { name: "Meeting 3", duration: 2.5, type: :offsite },
  { name: "Meeting 4", duration: 3, type: :onsite }
]

day3 = [
  { name: "Meeting 1", duration: 4, type: :offsite },
  { name: "Meeting 2", duration: 4, type: :offsite }
]

day4 = [
  { name: "Specs", duration: 2, type: :onsite },
  { name: "Client Meeting", duration: 1, type: :offsite },
  { name: "Client Meeting", duration: 0.5, type: :offsite },
  { name: "Lunch", duration: 0.5, type: :onsite },
  { name: "Development", duration: 2, type: :onsite },
]

Scheduler.schedule(day1)
Scheduler.schedule(day2)
Scheduler.schedule(day3)
Scheduler.schedule(day4)

# run via `ruby scheduler.rb`
