#!/usr/bin/ruby

months = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ]

downloaded = Array.new
IO.foreach("/home/chris/.flexget/flexget.log") do |l|
  downloaded.push(l) if l =~ /Downloading/
end

show_color = 236

downloaded.each do |l|
  l =~ /(\d+)-(\d+)-(\d+).*:\s(.*)\s-\sS(\d+)E(\d+).*(SD|HDTV|720p).*/
  year, month, day, show, season, episode, quality = $1, months[$2.to_i-1], $3, $4, $5, $6, $7

  puts("\e[38;5;#{show_color}m #{show} \e[0m".ljust(40) + "S#{season}E#{episode} \e[34m|| \e[0mdownloaded on \e[33m#{day} #{month} #{year}\e[0m".rjust(35))

  show_color = 236 if show_color == 248
  show_color = show_color + 1 if show_color != 248
end
