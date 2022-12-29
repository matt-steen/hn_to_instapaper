require_relative "config"
require_relative "hacker_news_client"
require_relative "instapaper_client"

# script to pull articles from HN and post them to Instapaper
hn_client = HackerNewsClient.new

date = Date.new(2022, 9, 16) - 1
count = 1

puts "pulling top #{count} articles for #{date}"
puts

posts = hn_client.get_top_posts(date, count)

ip_client = InstapaperClient.new(Config::INSTAPAPER_USERNAME, Config::INSTAPAPER_PASSWORD)

posts.each do |post|
  title = post[0]
  url = post[1]
  puts "adding post: #{title}"
  ip_client.add_url(url, title)
end
