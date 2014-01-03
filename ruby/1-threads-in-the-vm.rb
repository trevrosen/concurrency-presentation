# Threads aren't GC'd until you join them
# Threads can return values but you can't 'return' within them
# Threads can be stopped/started externally and internally (careful!)

if Thread.current == Thread.main
  puts "The main thread is the calling thread -- #{Thread.current}"
end

a = Thread.new{ "Live from a child thread: #{Thread.current}"}
b = Thread.new{ rand(500) }
c = Thread.new{ "Threads are mysterious but also kind of awesome" }
d = Thread.new{ puts "I (#{Thread.current}) AM THE INFINITE LOOP!"; loop do; end}

# How many threads is the VM tracking now?
puts "Tracking #{Thread.list.size}"

# Thread#value gives you the value of the last statement in the thread
# sort of like a method.  Why do you think it has to work this way?
puts "Here are the values returned by the child threads:"
puts a.value
puts b.value
puts c.value

puts "Now imma kill the infinite loop thread from the main thread - #{Thread.kill(d)} -- BOOM!"

# Threads are only garbage collected when they are all joined
[a,b,c,d].map(&:join)

puts "The calling thread is the only one left"
p Thread.list

# LocalJumpError - can't return from inside a thread, silly!
Thread.new{ return  }.join
puts "This line won't run"
