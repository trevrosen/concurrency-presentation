# When you absolutely have to use the same memory in two
# different threads, Mutex enables guaranteed exclusive 
# access to the shared resource.

# Example adapted from http://www.dreamincode.net/forums/topic/166151-threading/

counter1, counter2 = 0, 0
difference         = 0
semaphore          = Mutex.new

counter = Thread.new{
  loop do
    semaphore.synchronize do
      counter1 += 1
      sleep 0.1
      counter2 += 1
    end
  end

} 

calculator = Thread.new{
  loop do
    #difference += (counter1 - counter2).abs
    semaphore.synchronize{ difference += (counter1 - counter2).abs }
  end
}

# Try taking out the line below and running it over and over to see what happens
#[foo, bar].map(&:join)

sleep 1

puts "Counter 1: #{counter1}"
puts "Counter 2: #{counter2}"
puts "Difference: #{difference}"



## -- Without Locks ---
# (comment out *only* lines 13, 17, and 25)
# 
# Without locks, you'll get output like this:
# Counter 1: 10
# Counter 2: 9
# Difference: 10766652
#
# What you're seeing there is about all the incrementing that can be
# done on the counterX variables in 1 second given the 0.1 second sleep.
# Meanwhile, on the other thread, the difference number is going mad
# updating itself a gazillion times w/ the sum of the counters.



## -- WITH Locks ---
# (comment out *only* line 24)
#
# Counter 1: 10
# Counter 2: 9
# Difference: 0
#
# Here the difference will always be 0, because the lock ensures that
# the calculator thread can't do its calculation until both of the
# countX variables have been incremented.  NOTE: you may see a value for
# counter1 or counter2 that would make you think difference should be > 0.
# This is because the child thread is racing the puts statement itself
# in the main thread.  The bottom line is that the mutex ensures that the
# difference is zero and that both values are updated, so what you're seeing 
# is a display difference only.
