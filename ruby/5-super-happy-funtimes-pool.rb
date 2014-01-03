# A pool of threads is a good solution when you
# need to do a bunch of IO-based work.  Network
# IO lends itself well to multithreading inherently 
# because of the natural latency present in all
# networks.
#
#
require "nokogiri"
require "open-uri"
require "benchmark"

# A very important class for finding the titles of things
# on the tubes.  Talk to Trevor if you're interested in 
# angel investment opportunities for WebTitle.  Patent pending.
# All rights and licenses and honors and awards greedily reserved.
class WebTitle
  attr_reader :origin
  attr_accessor :doc

  def self.collect_and_print_these(urls, thread_limit)
    if thread_limit > 1
      puts "[*] Running multi-threaded"
      puts "[*] #{thread_limit} threads"
      fetch_multi_threaded(urls, thread_limit)
    elsif thread_limit == 1
      puts "[*] Running single-threaded"
     fetch_single_threaded(urls)
    else
      fail "thread_limit must be a positive integer" 
    end
  end

  # Fetch the URLs multi-threaded, blocking the calling
  # thread until done.
  #
  #
  # NOTE: if you think the Thread might raise an exception,
  # (which face it, it probably could unless it's a toy)
  # you can't Thread#exit in a rescue because it will end up
  # getting joined and exit the process.
  def self.fetch_multi_threaded(urls, thread_limit)
    queue   = Queue.new
    urls.each{|u| queue << u } 
    puts "The queue is size: #{queue.size}"

    http_threads = Array.new(thread_limit) do
      Thread.new do
        loop do  # Each thread infinitely loops, pulling items out of the queue until it hits a break condition
          begin
            title = new(queue.pop(true))  # true b/c this shouldn't block when queue is empty
            title.fetch
            puts title.text
          rescue ThreadError, TimeoutError => e
            # Queue#pop(true) will raise ThreadError when Queue#empty? is true
            # so this is the exit condition for Thread.current.
            if queue.empty?
              break

            # I just put this because it was happening sometimes on the web
            # and it was getting annoying.
            elsif e.is_a? TimeoutError
              puts "Timeout: #{e}"
              break

            # A real exception!
            else
              raise e
            end
          end
        end
      end
    end
    # You see this all the time in Ruby threading examples, but it's
    # naive.  Don't do this unless you are OK with boiling up 
    # exceptions to calling thread.
    #
    # http_threads.map(&:join)


    # Do this instead so you can handle the exceptions that happen
    # in child threads.
    http_threads.each do |t|
      begin
        t.join  
      rescue Exception => e
        puts e
      end
    end
  end

  # Fetch the URLs sequentially on the calling thread
  def self.fetch_single_threaded(urls)
    urls.each do |u|
      title = new(u)
      title.fetch
      puts title.text
    end
  end
    
  # Get a webpage from the internet and parse it into an
  # HTML document structure
  def fetch
    self.doc ||= Nokogiri::HTML(open(origin))
  end

  # Of the form "http://www.the-web-is-s00per.com"
  def initialize(http_url)
    @origin = http_url
  end

  # WebTitle just care about title
  def text
    @text ||= doc.css('title').inner_html
  end
end


#### USAGE OF OUR MASTERFUL CLASS ##### ---------------------------------------

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


# Run multi-threaded by default
# or pass in a number of threads.
Benchmark.bm do |x|
  x.report do
    #WebTitle.collect_and_print_these(web_urls, ARGV[1] || web_urls.size)
    WebTitle.collect_and_print_these(web_urls, ARGV[1] || 10)
  end
end

