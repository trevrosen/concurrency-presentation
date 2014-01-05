# Exceptions raised in threads whose caller is sleeping
# won't bubble up.
silent_scream = Thread.new do
  puts "You'd never know it, but I'm about to freak"
  fail
end

sleep 0.5



# Joining threads means their Exceptions come up to the calling
# thread's context
exceptional_thread = Thread.new do
  fail "PAAAAAANIC!"
end

exceptional_thread.join
