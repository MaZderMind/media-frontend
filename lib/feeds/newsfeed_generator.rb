require 'rss/maker'

module Feeds
  # Atom news feed generator.
  module NewsFeedGenerator

    # Generate atom feed for given news.
    #
    # @example Generate atom feed for given news
    #   news = News.all
    #   Feeds::NewsFeedGenerator.generate(news)
    #     #=> "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<feed xmlns=\"http://www.w3.org/2005/Atom\" …"
    #
    # @param news [Array<News>] should be generate to an atom feed
    # @param options [Hash] to define feed preferences
    # @option opts [String] :author Feed author
    # @option opts [String] :about Feed about text
    # @option opts [String] :title Feed title
    #
    # @return [String] atom feed
    def self.generate(news, options: {})
      atom_feed = build_feed(news, options)
      atom_feed.to_s
    end

    # Build atom feed object for given news.
    #
    # @example Generate atom feed object for given news
    #   news = News.all
    #   Feeds::NewsFeedGenerator.events(news) #=> #<RSS::Atom::Feed:0x007fbe057c218>
    #
    # @param news [Array<News>] to convert to an atom feed
    # @param options [Hash] to define feed preferences
    # @option opts [String] :author Feed author
    # @option opts [String] :about Feed about text
    # @option opts [String] :title Feed title
    #
    # @return [RSS::Atom::Feed] atom feed
    def self.build_feed(news, options)
      RSS::Maker.make('atom') do |feed|
        assign_feed_options(feed, options)

        # Create feed item for every news
        news.each do |news|
          feed.items.new_item do |item|
            assign_item_options(item, news)
          end
        end
      end
    end

    protected

    # Assign news options to an atom feed item.
    #
    # @param item [RSS::Maker::Atom::Feed::Items::Item]
    # @param news [News] object
    def self.assign_item_options(item, news)
      item.updated     = Time.now.to_s
      item.title       = news.title
      item.id          = "#{news.id}"
      item.description = news.body
      item.published   = news.created_at
      item.updated     = news.updated_at
    end

    # Assign options like a title or an author to an atom feed.
    #
    # @param feed [RSS::Maker::Atom::Feed] atom feed
    # @param options [Hash] options
    def self.assign_feed_options(feed, options)
      feed.channel.author  = options[:author]
      feed.channel.updated = Time.now.to_s
      feed.channel.about   = options[:about]
      feed.channel.title   = options[:title]
    end
  end
end