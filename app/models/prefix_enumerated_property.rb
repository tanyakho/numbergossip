## This is for properties for which it is easy to precompute and store
## in memory all the terms about which one might wish to gossip.  The
## implementation assumes that the property is infinite in principle,
## so that there will be upper bounds outside the range of interest.
## Compare EnumeratedProperty.
class PrefixEnumeratedProperty < ComputableProperty

  ## TODO Unit test!

  def initialize(elts)
    @elts = elts.sort
  end

  include FormulaProperty

  def generate(k)
    @elts[k-1]
  end

  def index_upper_bound(n)
    [n+2, @elts.length].min
  end

  def knowledge_bound
    @elts[-1]
  end

end
