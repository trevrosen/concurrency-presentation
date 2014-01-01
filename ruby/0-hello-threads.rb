# Thread is Ruby's basic class for manipulating execution.
# The actual execution of each individual thread is
# scheduled by the Ruby VM, but we can make sure that
# our created threads both fire before we exit by using Thread#join

# Run this a few times in a row -- you won't get the same printed results
# in the same order every time.

t1 = Thread.new{ puts "Thread t1 (#{Thread.current.object_id}) is running"}
t2 = Thread.new{ puts "Thread t2 (#{Thread.current.object_id}) is running"}

puts "Calling thread (#{Thread.current.object_id})is running"

#sleep 5   # Maybe we could let it just sleep until they all execute.  That's a thing, right?

# No - don't sleep.  That's crazy. 
# Just make the calling thread wait for them all to finish.
[t1, t2].each{|t| t.join}
