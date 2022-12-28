require "httparty"

class HackerNewsClient
  include HTTParty

  def get_top_thirty(date)
    n = 30

    start = date.to_time.to_i
    stop = (date + 1).to_time.to_i
    exp_start = 1663214400
    exp_stop = 1663300800

    response = HTTParty.get("https://hn.algolia.com/api/v1/search?numericFilters=created_at_i%3E#{start},created_at_i%3C#{stop}&hitsPerPage=#{n}")

    # puts response.body, response.code, response.message, response.headers.inspect
    if response.code < 200 || response.code >= 300
      puts "error calling HN API (#{response.code}): #{response.body}"
      return
    end

    body = JSON.parse(response.body)

    puts "found #{body["hits"].size} articles:"

    body["hits"].each do |hit|
      title = get_title(hit)
      url = get_url(hit)

      puts title
      puts url
    end
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
