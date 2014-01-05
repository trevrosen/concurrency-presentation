# This file illustrates some of the ways you mess with threads,
# relying on the controls available for dealing with them as they
# are being executed by the Ruby VM.
#
# NOTE: there's nothing in this code to prevent puts statements from
# stepping on each other as they go to STDOUT.
#
# FUN FACTS
# - Threads can return values but you can't 'return' within them
# - Threads can be stopped from the inside and started from the outside


# Thread.current is always the currently executing Thread
# Thread.main is the main, top-level Thread for the process.
if Thread.current == Thread.main
  puts "The main thread is the calling thread -- #{Thread.current}"
end

# Here we just do very fast things in threads:
#   - Dump a string containing the memory address of the thread
#   - Return a random integer up to 500
a = Thread.new{ "[- child thread -] Live from a child thread: #{Thread.current}"}
b = Thread.new{ "[- child thread -] Random int: #{rand(500)}" } 


# The next thread illustrates stopping a thread mid-execution.  It will block
# until it's called to start again with Thread#run.  Because this thread
# is joined with the calling thread lower in the code, it will block
# the process until it's started again.
stopped = Thread.new do 
            puts "[- child thread -] Threads are mysterious but also kind of awesome - ooooosttopping nowwww"; 
            Thread.stop 
            "[- child thread -]Now I'm **unstopped**"
          end



# The next thread will loop infinitely, giving us a chance to show off
# Ruby's Thread::kill method.
infinite = Thread.new do 
             puts "[- child thread -] I AM #{Thread.current} - THE INFINITE LOOP!" 
             loop do; end
           end

# Put arbitrary attributes on the thread - let's put
# names on them that we can grab later.
stopped[:name]  = "stopped"
infinite[:name] = "infinite"  

# How many threads is the VM tracking now?
puts "[- main thread -] #{(Thread.list - [Thread.current]).size} child threads are running or runnable"
puts "[- main thread -] Thread names: #{(Thread.list - [Thread.current]).map{|t| t[:name]}.join(',')}"

# Thread#value gives you the value of the last statement in the thread block.
puts "[- main thread -] Here are the values returned by the *finished* child threads:"
puts a.value
puts b.value

puts "[- main thread -] Now imma start the mysterious stopping thread again - #{stopped.run} -- BOOM!"
puts stopped.value

puts "[- main thread -] Now imma kill the infinite loop thread from the main thread - #{Thread.kill(infinite)} -- BOOM!"

# Threads are only garbage collected when they are all joined
[a, b, stopped, infinite].map(&:join)

puts "[- main thread -] The main/calling thread is the only one left - #{Thread.list}"

# LocalJumpError - can't return from inside a thread, silly!
Thread.new{ return  }.join
puts "This line won't ever run"
