require_relative "hacker_news_client"

# script to pull articles from HN and post them to Instapaper
hn_client = HackerNewsClient.new

hn_client.get_top_thirty(Date.new(2022, 9, 16) - 1)
