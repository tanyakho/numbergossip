## This is for finite properties, all of whose elements can be easily
## enumerated.  It may not behave well if more terms are requested
## than the property has.  At the moment, this is only used for the
## property of being 1, which is relevant in the definition of the
## composite numbers as being neither prime nor 1.  Compare
## PrefixEnumeratedProperty.
class EnumeratedProperty < ComputableProperty

  def initialize(*elts)
    @elts = elts.sort
  end

  def test(n)
    @elts.include? n
  end

  # Exclusive
  def count(bound)
    @elts.select { |num| num < bound }.length
  end

  def smallest_numbers(count)
    # Hm.  I don't know how much I like opening this can of worms...
    # This allows foo.smallest_numbers(count).length not to be equal to count
    true_count = count >= @elts.length ? @elts.length : count
    @elts[0...count]
  end

  def knowledge_bound
    PropertyComputer.infinity
  end

end
