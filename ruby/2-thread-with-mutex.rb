# When you absolutely have to use the same memory in two
# different threads, Mutex enables guaranteed exclusive 
# access to the shared resource.


counter   = 0
semaphore = Mutex.new

foo = Thread.new{
  semaphore.synchronize{  counter += 1; puts "#{counter} - updated in A" }
} 

bar = Thread.new{
  semaphore.synchronize{  counter += 2; puts "#{counter} - updated in B" }
}

# Try taking out the line below and running it over and over to see what happens
[foo, bar].each{|t| t.join }
