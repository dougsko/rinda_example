#!/usr/bin/env ruby

require 'rinda/ring'
require 'rinda/tuplespace'

class PrimeFinder

  def self.run
    DRb.start_service
    new.find
  end

  def initialize
    ts = Rinda::RingFinger.primary.read([:name, :TSPF, DRbObject, nil])[2]
    @ts = Rinda::TupleSpaceProxy.new ts # for safety
  end

  def find
    loop do
      start = @ts.take([:current, nil]).last # start of our search space
      finish = start + @ts.read([:step, nil]).last # items in our search space
      @ts.write [:current, finish] # write it back

      primes = @ts.read_all([:prime, nil]).map { |_,v| v } # read all primes

      start.upto finish do |candidate|
        next unless prime_in? candidate, primes

        top = Math.sqrt(candidate).to_i

        next unless prime_in? candidate, (start..top)

        @ts.write [:prime, candidate] # add to the found list
        primes << candidate
      end
    end
  end

  def prime_in?(candidate, range)
    range.all? do |value|
      value < candidate and candidate % value != 0
    end
  end

end

PrimeFinder.run
