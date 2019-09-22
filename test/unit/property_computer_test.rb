require File.dirname(__FILE__) + '/../test_helper'

class PropertyComputerTest < ActiveSupport::TestCase
  fixtures :properties, :property_occurrences, :knowledge_gaps

  def test_even_testing
    assert PropertyComputer::Even.test(12)
    assert !PropertyComputer::Even.test(13)
    assert @even.testable?, "Even is not testable, but should be."
    assert @even.test(12)
    assert !@even.test(13)
    assert_equal [@abundant, @composite, @even, @evil], Property.properties_of(12)
  end

  def test_smallest_even_numbers
    assert_equal [2,4,6,8,10,12], @even.smallest_numbers(6)
  end

  def test_count_even_numbers
    assert @even.count_computable?
    assert_equal 20, @even.count(41)
  end

  def test_odd_numbers
    assert PropertyComputer::Odd.test(45)
    assert !PropertyComputer::Odd.test(46)
    assert_equal 1, PropertyComputer::Odd.index(2)
    assert_equal 2, PropertyComputer::Odd.index(3)
  end

  def test_evil_odious_testing
    assert @odious.test(2)
    assert !@evil.test(2)
    assert !@odious.test(2000)
    assert @evil.test(2000)
  end

  def test_evil_odious_counting
    assert_equal 0, @evil.count(3)
    assert_equal 2, @odious.count(3)
    assert_equal 1, @evil.count(4)
    assert_equal 2, @odious.count(4)
    assert_equal 1, @evil.count(5)
    assert_equal 3, @odious.count(5)
  end

  def test_evil_odious_production
    assert_equal [3,5,6,9,10,12,15,17,18,20,23,24,27,29,30], @evil.smallest_numbers(15)
    assert_equal [1,2,4,7,8,11,13,14,16,19,21,22,25,26,28], @odious.smallest_numbers(15)
  end

  def test_composite_numbers
    assert @composite.testable?
    assert @composite.test(4)
    assert !@composite.test(5)
    assert_equal 4, @composite.count(10)
    assert_equal [2,3,5,7,11], @prime.smallest_numbers(5)
    assert_equal [4,6,8,9,10], @composite.smallest_numbers(5)
    assert !@composite.test(1)
  end

  def test_deficient_numbers
    assert @deficient.testable?
    assert @deficient.test(4)
    assert @deficient.test(7)
    assert !@deficient.test(6)
    assert !@deficient.test(20)
    assert_equal [1,2,3,4,5,7,8,9,10,11,13,14,15,16,17], @deficient.smallest_numbers(15)
    assert_equal 16, @deficient.count(20)
  end

  def test_knowledge_bounds
    assert_equal PropertyComputer.infinity, @even.knowledge_bound
    assert_equal PropertyComputer.infinity, @evil.knowledge_bound
    assert_equal PropertyComputer.infinity, @odious.knowledge_bound
    assert_equal 19, @prime.knowledge_bound
    assert_equal 19, @composite.knowledge_bound
    assert_equal 14, @square_free.knowledge_bound
    assert_equal 24, @abundant.knowledge_bound
    assert_equal 20, @deficient.knowledge_bound
    assert_equal 20, @perfect.knowledge_bound
    assert_equal 8, @fibonacci.knowledge_bound
    assert_equal 300, @apocalyptic_power.knowledge_bound
  end

  def test_knowledge
    7000.upto(7010) do |num|
      assert @even.known?(num)
      assert @evil.known?(num)
      assert @odious.known?(num)
    end
  end

  def test_squares
    assert @square.testable?
    assert @square.test(16)
    assert !@square.test(17)
    assert_equal 4, @square.count(17)
    assert_equal 3, @square.count(16) # count is exclusive
    assert_equal 99, @square.count(10000) # count is exclusive
    assert_equal [1, 4, 9, 16, 25, 36, 49, 64, 81, 100], @square.smallest_numbers(10)
    assert @square.knowledge_bound_computable?
    assert_equal PropertyComputer.infinity, @square.knowledge_bound
  end

  def test_enumeration
    @the_two = EnumeratedProperty.new(1, 8)
    assert @the_two.test(1)
    assert @the_two.test(8)
    assert !@the_two.test(4)
    assert !@the_two.test(100)
    assert_equal [1], @the_two.smallest_numbers(1)
    assert_equal [1, 8], @the_two.smallest_numbers(2)
    assert_equal [1, 8], @the_two.smallest_numbers(3)
    assert_equal 1, @the_two.count(4)
    assert_equal 2, @the_two.count(50)
    assert_equal PropertyComputer.infinity, @the_two.knowledge_bound
  end

end
