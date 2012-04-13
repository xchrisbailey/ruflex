#!/usr/bin/ruby
require "getopt/long"
require "action_view"
include ActionView::Helpers::DateHelper
require 'date'

Flexlog = "#{ENV['HOME']}/.flexget/flexget.log" # standard location of flexget.log
COLORS = (236..246).to_a # Grayscale color array

class Object
  def blank?
    self.nil? or self == 0 or self == ""
  end
end

opt = Getopt::Long.getopts(
  ['--clear', '-c', Getopt::BOOLEAN ]
)

if opt["clear"]
  File.delete(flexlog)
  puts "The flexget log file has been deleted"
  exit 1
end

downloads = Array.new

IO.foreach(Flexlog) do |f|
  next if f =~ /REJECTED/
  if f =~ /download/
    f =~ /(\d{4}-\d{2}-\d{2} \d{2}:\d{2}).*Downloading: (\w.*?) - ([sS]\d.[eE]\d.).*/
    date, series, epse = $1, $2, $3
  end

  unless date.blank?
#    new_date = Date.parse date
    downloads.push("#{date} #{series} #{epse}")
  end
end

downloads.uniq!
show_color = 0
downloads.each do |file|
  file =~ /(\d{4}-\d{2}-\d{2} \d{2}:\d{2})(.*?)S(\d{2})E(\d{2})/
  time, series, season, episode = DateTime.strptime($1, '%Y-%m-%d %H:%M'), $2, $3, $4

  puts("\e[38;5;#{COLORS[show_color]}m#{series}> S#{season}E#{episode} ".rjust(60) + "\e[0m\e[34m| \e[38;5;#{COLORS[show_color]}mdownloaded #{distance_of_time_in_words_to_now(time)} ago\e[0m".ljust(45))

  if show_color == COLORS.length - 1
    COLORS.reverse!
    show_color = 0
  else
    show_color = show_color + 1
  end
end
