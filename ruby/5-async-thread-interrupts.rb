# NOTE: this represents some new behavior that I wanted to demo but that
# I don't really understand all that well yet.  Depending on the common
# level of understanding of concurrency in general during this talk, we
# will spend more or less time on this example/demo.
#
# --- Asynchronous Interrupt Handling ----
# In Ruby 2.0, we get the ability to defer the handling of exceptions
# in situations where a child thread raises an exception in its parent.
# 
# The most obvious/common example of this is when a child thread raises a
# TimeoutError in its parent.
#
# This post has a decent explanation:
# http://globaldev.co.uk/2013/03/ruby-2-0-0-in-detail/#asynchronous_thread_interrupt_handling

if RUBY_VERSION < "2.0.0"
  puts "You need Ruby 2.x for this demo"
  exit 1
end

class GonzoError < Exception; end

# Here, the child thread is raising an exception on the parent thread.
# Ruby calls this kind of thread-to-thread exception raising an "interrupt".
# Starting in Ruby 2.0, we can handle these "interrupts" at a time 
# of our choosing.
#
# A weird thing here though is that I'm not sure (at the time of this
# writing) how we can *rescue* an interrupt exception.
Thread.handle_interrupt(GonzoError => :never) do
  parent = Thread.current

  # Child thread raises an exception in parent thread
  # but we will handle it later.
  child = Thread.new do
    puts "I exist only to spawn fail"
    #
    # Exception in the calling thread.  The most common example of this is an expiring Timeout
    parent.raise GonzoError
  end

  child.join

  5.downto(0) do |index|
    puts "I have to do just #{index} more thing(s)"
  end

  puts "<< MOAR IMPORTANT STUFF HAPPENING THAT I CAN'T STOP FOR >>"

  if Thread.pending_interrupt?
    puts "**NOW** I can allow the exception to happen"
    # Raise the exception now
    Thread.handle_interrupt(GonzoError => :never)
  end

  # Exception will raise here whether you handle the interrupt 
  # or not -- the Thread::pending_interrupt piece is just to 
  # show that you can conditionally execute code if an interrupt is pending.
  puts "This will never print"
end

# TODO: how would you handle the exception?  Try a begin..rescue..end
# block and see what happens in the stack trace.
