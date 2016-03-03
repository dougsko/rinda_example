#!/usr/bin/env ruby
# ringserver.rb
# Rinda RingServer

require 'rinda/ring'
require 'rinda/tuplespace'

DRb.start_service("druby://10.96.232.82:9999", Rinda::TupleSpace.new)

#DRb.start_service
#ts = Rinda::TupleSpace.new
#place = Rinda::RingServer.new(ts)

DRb.thread.join

