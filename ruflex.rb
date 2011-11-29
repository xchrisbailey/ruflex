#!/usr/bin/ruby
require "getopt/long"

opt = Getopt::Long.getopts(
  ['--clear', '-c', Getopt::BOOLEAN ]
)

if opt["clear"]
  File.delete('/home/chris/.flexget/flexget.log')
  puts "flexget has been removed"
  exit 1
end

Months = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ]
Colors = [ 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 246, 245, 244, 243, 242, 241, 240, 239, 238, 237, 236 ]

downloaded = Array.new
begin
  IO.foreach("/home/chris/.flexget/flexget.log") do |l|
    downloaded.push(l) if l =~ /Downloading/
  end
rescue
  puts "\e[31mNo new shows\e[0m"
  exit 1
end

puts "\e[31mNo new shows\e[0m" if downloaded.length == 0
exit if downloaded.length == 0

show_color = 0

Divider = '-' * 82
puts "\e[38;5;236m#{Divider}\e[0m"
downloaded.each do |l|
  next if l.include? "ERROR"
  l =~ /(\d+)-(\d+)-(\d+).*Downloading:\s(.*)\s-\sS(\d+)E(\d+).*(SD|HDTV|720p).*/
  year, month, day, show, season, episode, quality = $1, Months[$2.to_i-1], $3, $4, $5, $6, $7

  puts("\e[38;5;#{Colors[show_color]}m #{show} > S#{season}E#{episode}".rjust(55) + " \e[0m\e[34m| \e[38;5;#{Colors[show_color]}mdownloaded on \e[33m#{day} #{month} #{year}\e[0m".rjust(35))

  show_color = show_color + 1 if show_color != Colors.length - 1
  show_color = 0 if show_color == Colors.length - 1
end

puts "\e[38;5;236m#{Divider}\e[0m"
