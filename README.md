# HN -> Instapaper

This is an extraordinarily simple script to pull stories from [Hacker New](https://news.ycombinator.com/) and upload them to a personal [Instapaper](https://www.instapaper.com/) account.

## Usage
```
$ ruby update_feed.rb --help
Usage: update_feed.rb [options]
    -d, --date [DATE]                Date to pull top posts from (defaults to yesterday)
    -c, --count [COUNT]              Number of top posts to pull (defaults to 30)
        --confirm                    Whether to confirm each post during upload
```

To configure, copy the config file and set your Instapaper credentials:
```
cp config.rb.sample config.rb
```

When running, it raise an exception if authentication to Instapaper fails or if something goes wrong when adding a url.

## Implementation Details

This script is powered by the [Algolia HN API](https://hn.algolia.com/api) and the [Instapaper Simple API](https://www.instapaper.com/api/simple).

By default, it pulls the top 30 posts from the previous day in the system's time zone. It then parses the post title, HN id, points, and comment count. It concatenates the title, points, and comment count into an Instapaper title, and it uses the HN comments page for the story: https://news.ycombinator.com/item?id=<item_id>.
