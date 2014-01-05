![](https://github.com/trevrosen/concurrency-presentation/master/slides/img/lies.jpg?raw=true)


### Purpose

A presentation for the [AustinRB](http://austinrb.org) user group given in January 2014.

Aims to discuss and enlighten on two basic themes:

* Concurrency primitives and basic patterns in Ruby
* The [Celluloid](http://celluloid.io) library for enabling concurrency with the [actor
  model](http://en.wikipedia.org/wiki/Actor_model)


### Structure
* **ruby** - heavily commented example code using Thread, Queue, Mutex, etc
* **slides** - a [ RevealJS ](http://lab.hakim.se/reveal-js/#/) presentation


### Links

#### Stuff I found interesting while working on this

* The [definition of thread safety](http://en.wikipedia.org/wiki/Thread_safety)
* [The Actor model](http://en.wikipedia.org/wiki/Actor_model)
* Ilya Grigorik: [Parallelism is a Myth in Ruby](http://www.igvita.com/2008/11/13/concurrency-is-a-myth-in-ruby/)
* Yehuda Katz: [Threads (in Ruby): Enough already](http://yehudakatz.com/2010/08/14/threads-in-ruby-enough-already/)
* [Great example of Mutex](http://www.ruby-doc.org/core-2.0.0/Mutex.html) from core docs
* [Introduction to Celluloid](http://www.sitepoint.com/an-introduction-to-celluloid-part-i/) (a multi-part tutorial)
* Ruby [Atomic](https://github.com/headius/ruby-atomic) - a library implementing atomic reference access (use less of those annoying Mutex blocks).
* [Interview with Brian Shirai](http://www.jstorimer.com/blogs/workingwithcode/7766043-interview-brian-shirai-on-rubinius-2-0-the-gil-and-thread-safe-ruby-code), lead dev on Rubinius.  This one is fantastic for eliminating a lot of the thread FUD and really learning why multithreading is hard to implement in interpreters.  This gets into some great detail about the GIL.
* [Concurrency in Erlang and Scala](http://savanne.be/articles/concurrency-in-erlang-scala/)

#### RubyTapas links
Avdi Grimm's ["Ruby Tapas"](http://rubytapas.com) screencast series is truly excellent.  Awhile back, he did a series on threads that I found helpful.  Here are some links, basically here to show you the breadth of what he covers.  Subscribing to RubyTapas is a really good idea - you probably spend $9/month on less worthy stuff all the time.

* [Dead Thread](http://www.rubytapas.com/episodes/136-Dead-Thread)
* [Mutex](http://www.rubytapas.com/episodes/137-Mutex)
* [Threads are Hard](http://www.rubytapas.com/episodes/140-Threads-are-Hard)
* [Bounded Queue](http://www.rubytapas.com/episodes/141-Bounded-Queue)
* [Thread Interruptions](http://www.rubytapas.com/episodes/143-Thread-Interruptions)
* [Thread Pool](http://www.rubytapas.com/episodes/145-Thread-Pool)
* [Monitor](http://www.rubytapas.com/episodes/146-Monitor)
* [Atomicity](http://www.rubytapas.com/episodes/147-Atomicity)