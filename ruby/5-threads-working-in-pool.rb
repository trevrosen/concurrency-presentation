# A pool of threads is a good solution when you
# need to do a bunch of IO-based work.  Network
# IO lends itself well to multithreading inherently 
# because of the natural latency present in all
# networks.
