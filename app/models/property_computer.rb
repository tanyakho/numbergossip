## A PropertyComputer object is used to compute things about properties
## on the app server instead of asking the database for the answers.
## A PropertyComputer object can usefully supply the following methods:
##   count(bound)  # Exclusive
##   test(number)
##   knowledge_bound
##   next_after(base, count)
##   last_before(base, count)
##   number_of_repetitions(number)
## The classes ComputableProperty, ComplementaryProperty,
## DatabaseBackedProperty, EnumeratedProperty, and
## PrefixEnumeratedProperty, and the modules FormulaProperty and
## TestableProperty, capture common patterns of how these methods can
## be defined in terms of each other, more fundamental methods, or
## input data.
##
## Notes on semantics of computed properties:
## - counts are exclusive of the upper bound
## - knowledge bounds are inclusive (i.e. if knowledge_bound returns n, I know about n)
## - generate(k) returns the kth number with this property (1-indexed)
## - index(n) returns the index of the largest number like this <= n.
module PropertyComputer

  def self.infinity
    1000000000
  end

  Even = ComputableProperty.new.extend FormulaProperty
  def Even.generate(k)
    2 * k
  end
  def Even.index(n)
    n / 2
  end

  Odd = ComputableProperty.new.extend FormulaProperty
  def Odd.generate(k)
    2 * k - 1
  end
  def Odd.index(n)
    (n + 1) / 2
  end

  Evil = ComputableProperty.new.extend TestableProperty
  def Evil.test(n)
    PropertyComputer.bitcount(n) % 2 == 0
  end
  # Exclusive
  # Evil and odious numbers have the operation "I give you n,
  # you give me something slightly smaller than n and its index."
  def Evil.count(bound)
    included_even_odd_pairs = (bound / 2) - 1
    included_even_odd_pairs + (((bound - 1) % 2 == 0) && test(bound - 1) ? 1 : 0)
  end

  Odious = ComputableProperty.new.extend TestableProperty
  def Odious.test(n)
    PropertyComputer.bitcount(n) % 2 != 0
  end
  # Exclusive
  def Odious.count(bound)
    bound - Evil.count(bound) - 1
  end

  Cake = ComputableProperty.new.extend FormulaProperty
  def Cake.generate(k)
    (k*k*k + 5 * k + 6) / 6
  end

  # This indirection with the DatabaseBacked stuff is necessary because
  # Rails screws around with loading and reloading classes in development
  # mode, and normal Property objects appear to lose their class
  # and not regain it when that happens.
  Composite = ComplementaryProperty.new(DatabaseBackedProperty.new("primes"),
                                        EnumeratedProperty.new(1))

  Cube = ComputableProperty.new.extend FormulaProperty
  def Cube.generate(k)
    k*k*k
  end
  def Cube.index(n)
    # This will not give the right answer for *very* large numbers...
    Math.exp(Math.log(n+0.5) / 3.0).floor
  end

  Deficient = ComplementaryProperty.new(DatabaseBackedProperty.new("abundant numbers"),
                                        DatabaseBackedProperty.new("perfect numbers"))

# TODO The Fibonaccis are used in the regular test suite for several
# things, including an example of a repeated property.
#   Fibonacci = ComputableProperty.new.extend FormulaProperty
#   def Fibonacci.generate(k)
#     phi = (1 + Math.sqrt(5)) / 2.0
#     (phi ** k / Math.sqrt(5)).round
#   end

  LazyCaterer = ComputableProperty.new.extend FormulaProperty
  def LazyCaterer.generate(k)
    (k*k + k + 2) / 2
  end

  Pentagonal = ComputableProperty.new.extend FormulaProperty
  def Pentagonal.generate(k)
    (k*(3*k - 1)) / 2
  end

  PowerOf2 = ComputableProperty.new.extend FormulaProperty
  def PowerOf2.generate(k)
    2**(k-1)
  end
  def PowerOf2.index(n)
    # This will not give the right answer for *very* large numbers...
    (Math.log(n+0.5) / Math.log(2.0)).floor + 1
  end

  Pronic = ComputableProperty.new.extend FormulaProperty
  def Pronic.generate(k)
    k * (k + 1)
  end

  Repunit = ComputableProperty.new.extend FormulaProperty
  def Repunit.generate(k)
    ("1" * k).to_i
  end
  def Repunit.index_upper_bound(n)
    # This will not give the right answer for *very* large numbers...
    Math.log10(n+0.5).floor + 2
  end

  Square = ComputableProperty.new.extend FormulaProperty
  def Square.generate(k)
    k*k
  end
  def Square.index(n)
    # This will not give the right answer for *very* large numbers...
    Math.sqrt(n+0.5).floor
  end

  Tetrahedral = ComputableProperty.new.extend FormulaProperty
  def Tetrahedral.generate(k)
    (k * (k + 1) * (k + 2)) / 6
  end

  Triangular = ComputableProperty.new.extend FormulaProperty
  def Triangular.generate(k)
    k * (k + 1) / 2
  end

  def self.load_file(prop_name)
    Property.parse_property_file(File.dirname(__FILE__) + "/../../" + "db/properties/" + prop_name + ".file") do |numbers, gaps, bounds|
      # TODO What about knowledge gaps and manual bounds?
      numbers
    end
  end

  # TODO The unit tests use some of these
  Amicable = PrefixEnumeratedProperty.new(load_file("amicable_numbers"))
  Aspiring = PrefixEnumeratedProperty.new(load_file("aspiring_numbers"))
  Automorphic = PrefixEnumeratedProperty.new(load_file("automorphic_numbers"))
  Carmichael = PrefixEnumeratedProperty.new(load_file("carmichael_numbers"))
  Catalan = PrefixEnumeratedProperty.new(load_file("catalan_numbers"))
  Compositorial = PrefixEnumeratedProperty.new(load_file("compositorials"))
  Factorial = PrefixEnumeratedProperty.new(load_file("factorials"))
  # Fibonacci = PrefixEnumeratedProperty.new(load_file("fibonacci_numbers"))
  Google = PrefixEnumeratedProperty.new(load_file("google_numbers"))
  Hungry = PrefixEnumeratedProperty.new(load_file("hungry_numbers"))
  Mersenne = PrefixEnumeratedProperty.new(load_file("mersenne_numbers"))
  MersennePrime = PrefixEnumeratedProperty.new(load_file("mersenne_primes"))
  Narcissistic = PrefixEnumeratedProperty.new(load_file("narcissistic_numbers"))
  PalindromicPrime = PrefixEnumeratedProperty.new(load_file("palindromic_primes"))
  #  Perfect = PrefixEnumeratedProperty.new(load_file("perfect_numbers"))
  Primorial = PrefixEnumeratedProperty.new(load_file("primorials"))
  Vampire = PrefixEnumeratedProperty.new(load_file("vampire_numbers"))
  Weird = PrefixEnumeratedProperty.new(load_file("weird_numbers"))
  
 private
  def self.bitcount(number)
    count = 0
    while number > 0
      count = count + 1 if number % 2 != 0
      number = number / 2
    end
    count
  end

end
