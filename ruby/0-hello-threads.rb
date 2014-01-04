# Thread is Ruby's basic class for manipulating execution.
# The actual execution of each individual thread is
# scheduled by the Ruby VM, but we can make sure that
# our created threads both fire before we exit by just forcing
# our program to run for long enough.  Why not?

# Run this a few times in a row -- you won't get the same printed results
# in the same order every time.

t1 = Thread.new{ puts "Thread t1 (#{Thread.current.object_id}) is running"}
t2 = Thread.new{ puts "Thread t2 (#{Thread.current.object_id}) is running"}

puts "Calling thread (#{Thread.current.object_id})is running"

# Make the calling thread wait for them all to finish.
# This is dumb and you shouldn't actually do something like this.
# I'm just doing it here to prove a point
sleep 2
