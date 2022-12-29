require "httparty"

class HackerNewsClient
  include HTTParty

  def initialize
    # in theory, it should be possible to set base_uri for HTTParty, but that doesn't seem to work with
    # https without additional config
    @search_url = "https://hn.algolia.com/api/v1/search"
  end

  def get_top_posts(date, count = 30)
    query = get_query(date, count)
    response = HTTParty.get(@search_url, query: query)

    if response.code < 200 || response.code >= 300
      puts "error calling HN API (#{response.code}): #{response.body}"
      return []
    end

    body = JSON.parse(response.body)

    posts = []
    body["hits"].each do |hit|
      title = get_title(hit)
      url = get_url(hit)

      posts.append([title, url])
    end

    posts
  end

  private

  def get_query(date, count)
    start = date.to_time.to_i
    stop = (date + 1).to_time.to_i

    {
      hitsPerPage: count,
      numericFilters: "created_at_i>#{start},created_at_i<#{stop}"
    }
  end

  def get_title(hit)
    "#{hit["title"]} [#{hit["points"]}p, #{hit["num_comments"]}c]"
  end

  def get_url(hit)
    # using the tag with the story id, produce the link to the HN comments. that page has a link to the source
    # at the top, so it makes sense to use it as the url for instapaper
    hit["_tags"].each do |tag|
      if tag.start_with?("story_")
        return "https://news.ycombinator.com/item?id=#{tag[6..]}"
      end
    end

    # fallback to the source url
    hit["url"]
  end
end
