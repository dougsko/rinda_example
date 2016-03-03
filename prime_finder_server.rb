#!/usr/bin/env ruby
#
require 'rinda/ring'
require 'rinda/tuplespace'

class TupleSpacePrimeFinder

  def self.run
    DRb.start_service
    new.run
  end

  def initialize
    @ts = Rinda::TupleSpace.new
  end

  ##
  # Lists primes as they are added to the TupleSpace.

  def list_primes
    Thread.start do
      notifier = @ts.notify 'write', [:prime, nil]

      puts "primes found:"
      notifier.each do |_, t|
        puts t.last
      end
    end
  end

  def run
    list_primes

    @ts.write [:prime, 2] # seed prime
    @ts.write [:current, 2] # next value to search
    @ts.write [:step, 100] # range of values to search

    rp = Rinda::RingProvider.new :TSPF, @ts, 'PrimeFinder using TupleSpace'
    rp.provide

    DRb.thread.join
  end

end

TupleSpacePrimeFinder.run
