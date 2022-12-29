require_relative "config"
require_relative "hacker_news_client"
require_relative "instapaper_client"

require "io/console"
require "optparse"
require "optparse/date"

def get_char
  input = $stdin.getch
  control_c_code = "\u0003"
  exit(1) if input == control_c_code
  input
end

yesterday = Date.today - 1

# default to uploading yesterday's top 30, but support alternate dates, count, and confirmation for each post
options = {
  date: yesterday,
  count: 30,
  confirm: false
}
OptionParser.new do |opts|
  opts.banner = "Usage: update_feed.rb [options]"

  opts.on("-d", "--date [DATE]", Date, "Date to pull top posts from")

  opts.on("-c", "--count [COUNT]", OptionParser::DecimalInteger, "Number of top posts to pull")

  opts.on("--confirm", "Whether to confirm each post during upload")
end.parse!(into: options)

if options[:date] == Date.today
  puts "warning: using data for today (which will be incomplete). did you mean yesterday?"
  puts
end

puts "pulling top #{options[:count]} articles for #{options[:date]}"
puts

hn_client = HackerNewsClient.new

posts = hn_client.get_top_posts(options[:date], options[:count])

ip_client = InstapaperClient.new(Config::INSTAPAPER_USERNAME, Config::INSTAPAPER_PASSWORD)

posts.each do |post|
  title = post[0]
  url = post[1]
  if options[:confirm]
    puts "add post? #{title} (y/n)"

    input = get_char
    if input == "y"
      ip_client.add_url(url, title)
    end
  else
    puts "adding post: #{title}"
    ip_client.add_url(url, title)
  end
end
