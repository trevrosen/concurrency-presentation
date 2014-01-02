# A pool of threads is a good solution when you
# need to do a bunch of IO-based work.  Network
# IO lends itself well to multithreading inherently 
# because of the natural latency present in all
# networks.
#
#
#
#
require "nokogiri"
require "open-uri"
require "benchmark"

# A very important class for finding the titles of things
# on the tubes.  Talk to Trevor if you're interested in 
# angel investment opportunities for WebTitle.  Patent pending.
class WebTitle
  attr_reader :origin
  attr_accessor :doc

  def self.collect_and_print_these(urls, thread_limit)
    if thread_limit > 1
      puts "Running multi-threaded"
      fetch_multi_threaded(urls, thread_limit)
    elsif thread_limit == 1
      puts "Running single-threaded"
     fetch_single_threaded(urls)
    else
      fail "thread_limit must be a positive integer" 
    end
  end

  def self.fetch_multi_threaded(urls, thread_limit)
    threads = []
    queue   = Queue.new
    urls.each{|u| queue << u } 

    thread_limit.times do
      threads << Thread.new do
        begin
          title = new(queue.pop(true)) 
          title.fetch
          puts title.text
        rescue ThreadError => e
          if queue.empty?
            return
          else
            raise e
          end
        end
      end
    end
    threads.each{ |t| t.join }
  end


  def self.fetch_single_threaded(urls)
    urls.each do |u|
      title = new(u)
      title.fetch
      puts title.text
    end
  end
    
  def fetch
    self.doc ||= Nokogiri::HTML(open(origin))
  end

  def initialize(http_url)
    @origin = http_url
  end

  def text
    @text ||= doc.css('title')
  end
end


web_urls = [
  "http://google.com",
  "http://yahoo.com",
  "http://cnn.com",
  "http://apple.com",
  "http://amazon.com",
  "http://bbcnews.com",
  "http://slashdot.com",
  "https://github.com",
  "https://twitter.com",
  "http://instagram.com",
  "https://duckduckgo.com",
  "http://gawker.com",
  "http://io9.com",
  "https://github.com/trevrosen",
  "http://golang.org",
  "http://reddit.com",
  "http://reddit.com/r/netsec",
  "http://reddit.com/r/ruby",
  "http://reddit.com/r/golang",
  "http://reddit.com/r/austin",
  "http://reddit.com/r/programming",
]


WebTitle.collect_and_print_these(web_urls, ARGV[1] || web_urls.size)



