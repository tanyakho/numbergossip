## This is the base class for objects that compute properties.  The
## methods defined here are supplied for all computable properties.
class ComputableProperty

  ## TODO This is only useful to avoid breaking unit tests that
  ## access property computer objects directly.
  def smallest_numbers(count)
    next_after(0, count)
  end

  def number_of_repetitions(number)
    test(number) ? 1 : 0 # TODO Figure this one out properly...
  end

end
