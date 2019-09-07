require File.dirname(__FILE__) + '/../test_helper'

class ComputationTest < ActiveRecord::TestCase
  def assert_all_there(*numbers)
    numbers.each do |num|
      assert @computer.test(num), "#{num} should test as true"
    end
  end

  def assert_all_not_there(*numbers)
    numbers.each do |num|
      assert !@computer.test(num), "#{num} should not test as true"
    end
  end

  def assert_counts(expected_counts, indecies)
    assert_equal expected_counts, indecies.map { |ind| @computer.count ind }
  end

  def assert_generations(expected_generations, indecies)
    assert_equal expected_generations, indecies.map { |ind| @computer.generate ind }
  end

  def test_cake_numbers
    @computer = PropertyComputer::Cake
    assert_equal 8, @computer.generate(3)
    assert_all_there 2, 8, 9920
    assert_all_not_there 1, 3, 7, 9, 9919, 9921
    assert_equal [2, 4, 8, 15, 26, 42, 64, 93, 130, 176], @computer.smallest_numbers(10)
    assert_counts [9, 10, 39], [176, 177, 10000]
  end

  def test_cubes
    @computer = PropertyComputer::Cube
    assert_equal 1, @computer.generate(1)
    assert_equal 8, @computer.generate(2)
    assert_equal 27, @computer.generate(3)
    assert_all_there 125, 1000, 9261
    assert_all_not_there 999, 1001, 9260, 9262
    assert_equal [1, 8, 27, 64, 125], @computer.smallest_numbers(5)
    assert_counts [4, 5], [125, 126]
  end

#   def test_fibonacci_numbers
#     @computer = PropertyComputer::Fibonacci
#     assert_equal 3, @computer.index(2)
#     assert_all_there 1, 1, 2, 3, 55, 89, 6765
#     assert_all_not_there 4, 6, 7, 9, 10, 6764, 6766
#     assert_equal [1, 1, 2, 3, 5, 8, 13, 21, 34, 55], @computer.smallest_numbers(10)
#     assert_counts [9, 10, 19], [55, 56, 10000]
#   end

  def test_lazy_caterer_numbers
    @computer = PropertyComputer::LazyCaterer
    assert_generations [7, 16], [3, 5]
    assert_all_there 2, 7, 9871
    assert_all_not_there 1, 3, 6, 8, 9, 9870, 9872
    assert_equal [2, 4, 7, 11, 16, 22, 29, 37, 46, 56], @computer.smallest_numbers(10)
    assert_counts [9, 10, 140], [56, 57, 10000]
  end

  def test_pentagonal_numbers
    @computer = PropertyComputer::Pentagonal
    assert_generations [12, 22, 35], [3, 4, 5]
    assert_all_there 5, 117, 9801
    assert_all_not_there 4, 6, 116, 118, 9800, 9802
    assert_equal [1, 5, 12, 22, 35, 51, 70, 92, 117, 145], @computer.smallest_numbers(10)
    assert_counts [9, 10, 81], [145, 146, 10000]
  end

  def test_powers_of_two
    @computer = PropertyComputer::PowerOf2
    assert_equal 1, @computer.generate(1)
    assert_equal 16, @computer.generate(5)
    assert_equal 1, @computer.index(1)
    assert_equal 5, @computer.index(16)
    assert_all_there 1, 2, 4, 16, 1024
    assert_all_not_there 3, 1023, 1025
    assert_equal [1, 2, 4, 8, 16, 32, 64], @computer.smallest_numbers(7)
    assert_equal 14, @computer.count(10000)
    assert_equal PropertyComputer.infinity, @computer.knowledge_bound
  end

  def test_pronic_numbers
    @computer = PropertyComputer::Pronic
    assert_equal [2, 6, 12, 20, 30, 42, 56, 72, 90, 110], @computer.smallest_numbers(10)
    assert_counts [9, 10, 99], [110, 111, 10000]
  end

  def test_repunits
    @computer = PropertyComputer::Repunit
    assert_all_there 1, 11, 111, 1111
    assert_all_not_there 2, 10, 12, 110, 112, 1110, 1112, 4267
    assert_equal [1, 11, 111, 1111, 11111, 111111, 1111111, 11111111, 111111111, 1111111111], @computer.smallest_numbers(10)
    assert_counts [9, 10, 4], [1111111111, 1111111112, 10000]
  end

  def test_tetrahedral_numbers
    @computer = PropertyComputer::Tetrahedral
    assert_all_there 1, 4
    assert_all_not_there 2, 3, 5
    assert_equal [1, 4, 10, 20, 35, 56, 84, 120, 165, 220], @computer.smallest_numbers(10)
    assert_counts [9, 10, 38], [220, 221, 10000]
  end

  def test_triangular_numbers
    @computer = PropertyComputer::Triangular
    assert_equal [1, 3, 6, 10, 15, 21, 28, 36, 45, 55], @computer.smallest_numbers(10)
    assert_counts [9, 10, 140], [55, 56, 10000]
  end

end
