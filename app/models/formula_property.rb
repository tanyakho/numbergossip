## This is meant for properties whose kth numbers can be produced
## easily (as by a formula).  Ideally, the formula would also be
## invertible to easily tell how many numbers there are with this
## property before a given n.
##
## Assuming the includer has the methods 
## - generate(k), returns the kth number with this property
## - index(n), returns the index of the largest number <= n with this property
## will supply appropriate test, count, knowledge_bound, last_before,
## and next_after methods.  If index is not defined, will supply it
## with binary search.  The default bounds for the binary search are 0
## and n+1, but can be overridden via the methods index_lower_bound
## and index_upper_bound.
module FormulaProperty

  def test(n)
    ind = index(n)
    ind > 0 and n == generate(ind)
  end

  # Exclusive
  def count(bound)
    index(bound - 1)
  end

  def next_after(base, count = Property.neighbor_width)
    ind = index(base)
    (ind+1..ind+count).map { |k| generate(k) }
  end

  def last_before(base, count = Property.neighbor_width)
    lim_ind = index(base - 1)
    start = [ lim_ind - count + 1, 1 ].max
    (start..lim_ind).map { |k| generate(k) }
  end

  def knowledge_bound
    PropertyComputer.infinity
  end

  def index(n)
    index_lower_bound(n).binary_search(index_upper_bound(n)) do |candidate|
      generate(candidate) <= n
    end
  end

  def index_lower_bound(n)
    0
  end

  def index_upper_bound(n)
    n + 2
  end
end

class Integer

  # Invariant: condition is true on self and false
  # on upper bound.
  # Returns: largest integer satisying condition
  def binary_search(upper_bound, &condition)
    if upper_bound == self + 1
      self
    else
      mid_point = (upper_bound + self) / 2
      if yield mid_point
        mid_point.binary_search(upper_bound, &condition)
      else
        self.binary_search(mid_point, &condition)
      end
    end
  end

end
