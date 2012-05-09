#!/usr/bin/ruby

require 'getopt/long'
require 'action_view'
include ActionView::Helpers::DateHelper
require 'date'

Flexlog = "#{ENV['HOME']}/.flexget/flexget.log" # location of your flexget.log file
COLORS    = (236..247).to_a                     # set out output colors

# object blank? {{{
class Object
  def blank?
    self.nil? or self == 0 or self == ""
  end
end
#}}}

class Ruflex

  # initialize/run magic {{{
  def initialize(flexlog)
    begin
      show_count = 0
      show_color = 0

      File.open(flexlog).grep(/download/).each do |d|
        next if d =~ /REJECTED/ # move on if download was rejected
        show_count += 1
        date, series, episode = self.class.clean_up(d)  # grab date series season and episode from flexlog string
        next if date.blank?

        date = DateTime.strptime(date, '%Y-%m-%d %H:%M') # make datetime object

        puts("\e[38;5;#{COLORS[show_color]}m#{series} > #{episode} \e[0m\e[34m| ".rjust(66) + "\e[38;5;#{COLORS[show_color]}mdownloaded #{distance_of_time_in_words_to_now(date)} ago\e[0m")
        if show_color == COLORS.length - 1
          COLORS.reverse!
          show_color = 0
        else
          show_color = show_color + 1
        end
      end
      no_shows("new shows") if show_count == 0  # if no new shows print and exit
    rescue
      no_shows("flexget.log file found") # if no log file print and exit
    end
  end
  #}}}

  # clean_up file method {{{
  def self.clean_up(line)
    line =~ /(\d{4}-\d{2}-\d{2} \d{2}:\d{2}).*Downloading: (\w.*?) - ([sS]\d.[eE]\d.).*/
    return $1, $2, $3
  end
  #}}}

  # no_show error message {{{
  def no_shows(error)
    puts "\e[31mNo #{error}\e[0m"
    exit 1
  end
  #}}}

end

# delete flexlog file opt {{{
opt = Getopt::Long.getopts(
  ['--clear', '-c', Getopt::BOOLEAN ]
)

if opt["clear"]
  File.delete(Flexlog)
  puts "#{Flexlog} has been deleted"
  exit 1
end
#}}}

Run = Ruflex.new(Flexlog)
