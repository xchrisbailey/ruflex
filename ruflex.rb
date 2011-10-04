#!/usr/bin/ruby

months = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ]
colors = [ 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 247, 246, 245, 244, 243, 242, 241, 240, 239, 238, 237, 236 ]

downloaded = Array.new
IO.foreach("/home/chris/.flexget/flexget.log") do |l|
  downloaded.push(l) if l =~ /Downloading/
end

show_color = colors[0]

downloaded.each do |l|
  l =~ /(\d+)-(\d+)-(\d+).*Downloading:\s(.*)\s-\sS(\d+)E(\d+).*(SD|HDTV|720p).*/
  year, month, day, show, season, episode, quality = $1, months[$2.to_i-1], $3, $4, $5, $6, $7

  puts("\e[38;5;#{show_color}m #{show}".ljust(40) + ">S#{season}E#{episode} \e[0m\e[34m|| \e[0mdownloaded on \e[33m#{day} #{month} #{year}\e[0m".rjust(35))

  show_color = show_color + 1 if show_color != colors.length - 1
  show_color = 0 if show_color == colors.length - 1
end

