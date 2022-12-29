require_relative "hacker_news_client"

# script to pull articles from HN and post them to Instapaper
hn_client = HackerNewsClient.new

date = Date.new(2022, 9, 16) - 1
count = 1

puts "pulling top #{count} articles for #{date}"
puts

posts = hn_client.get_top_posts(date, count)

posts.each { |post| puts post }
