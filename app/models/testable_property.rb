## This is meant for properties that are easy to test for directly but
## whose kth numbers are not easy to produce (else FormulaProperty
## would be preferable).  Assuming the includer has a test(number)
## method, supplies appropriate next_after, last_before, and
## knowledge_bound methods.  The algortihms used assume that the
## property is reasonably dense, so that walking along the integers
## and testing them one by one is a reasonable thing to do.  The count
## method is expected to be provided separately.
module TestableProperty

  def next_after(base, count = Property.neighbor_width)
    ans = []
    while count > 0 and num = next_one_after(base + 1) do
      ans += [ num ]
      count -= 1
      base = num
    end
    ans
  end

  # Inclusive
  def next_one_after(n)
    if n > knowledge_bound
      nil
    else
      if test(n)
        n
      else
        next_one_after(n + 1)
      end
    end
  end

  def last_before(base, count = Property.neighbor_width)
    ans = []
    while count > 0 and num = last_one_before(base - 1) do
      ans += [ num ]
      count -= 1
      base = num
    end
    ans.reverse
  end

  # Inclusive
  def last_one_before(n)
    if n > knowledge_bound || n <= 0
      nil
    else
      if test(n)
        n
      else
        last_one_before(n - 1)
      end
    end
  end

  def knowledge_bound
    PropertyComputer.infinity
  end

end
