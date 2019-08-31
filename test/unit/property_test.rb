require File.dirname(__FILE__) + '/../test_helper'

class PropertyTest < Test::Unit::TestCase
  fixtures :properties, :property_occurrences, :knowledge_gaps

  def setup
    @even_numbers = Property.find(1)
    @fibonacci_numbers = Property.find(2)
  end

  def test_truth
    assert_kind_of Property,  @even_numbers
  end
  
  def test_properties
    assert_equal [@deficient, @even_numbers, @fibonacci_numbers, @odious, @prime, @square_free], Property.properties_of(2)
    assert_equal [@deficient, @evil, @fibonacci_numbers, @prime, @square_free], Property.properties_of(3)
    assert_equal [@composite, @deficient, @even_numbers, @odious, @square], Property.properties_of(4)
    assert_equal [@composite, @deficient, @even_numbers, @fibonacci_numbers, @odious], Property.properties_of(8)
  end

  def test_testing
    assert @fibonacci.test(3)
    assert !@fibonacci.test(4)
    assert @apocalyptic_power.test(157)
    assert !@apocalyptic_power.test(158)
    assert @prime.test(2)
  end

  def test_counting
    assert_equal 5, @fibonacci.count
    assert_equal 6, @fibonacci.count_with_multiplicity
    assert_equal 3, @fibonacci.count(5)
    assert_equal 4, @fibonacci.count_with_multiplicity(5)
    assert @fibonacci.duplicates_present?
    assert @fibonacci.duplicates_present?(5)
    assert_equal 1, @perfect.count
    assert_equal 0, @perfect.count(5)
    assert !@perfect.duplicates_present?
    assert !@perfect.duplicates_present?(5)
  end

  def test_repetition_counting
    assert_equal 1, @perfect.number_of_repetitions(6)
    assert_equal 0, @perfect.number_of_repetitions(5)
    assert_equal 0, @fibonacci.number_of_repetitions(6)
    assert_equal 1, @fibonacci.number_of_repetitions(5)
    assert_equal 2, @fibonacci.number_of_repetitions(1)
    assert_equal 1, @evil.number_of_repetitions(3)
    assert_equal 0, @evil.number_of_repetitions(4)
  end

  def test_smallest
    assert_equal [1,1,2,3,5,8], @fibonacci.smallest_numbers(6)
    assert_equal [1,1,2], @fibonacci.smallest_numbers(3)
    assert_equal [6], @perfect.smallest_numbers(1)
  end

  def test_finding
    assert_equal [222, 224, 226], @apocalyptic_power.next_after(220)
    assert_equal [], @apocalyptic_power.next_after(300)
    assert_equal [157, 192, 218], @apocalyptic_power.last_before(220)
    assert_equal [16, 25, 36, 49], @square.next_after(9, 4)
    assert_equal [1, 4], @square.last_before(6)
    assert_equal [16, 18], @composite.next_after(15)
    assert_equal [], @composite.next_after(25)
    assert_equal [6, 8, 9], @composite.last_before(10)
    assert_equal [4, 6, 8, 9], @composite.last_before(10, 10)
    assert_equal [], @composite.last_before(4, 10)
    assert_equal [7, 8, 11], @odious.next_after(4)
    assert_equal [1, 2], @odious.last_before(4)
  end

  def test_load_from_file
    assert_equal [], @loaded_property.smallest_numbers(5)
    @loaded_property.load_from_file("test/fixtures/evil.file")
    @loaded_property = Property.find(@loaded_property.id) # Clobber in-memory state
    assert_equal [3,5,6,9,10], @loaded_property.smallest_numbers(5)
    assert_equal [@deficient, @evil, @fibonacci_numbers, @loaded_property, @prime, @square_free], Property.properties_of(3)
  end

  def test_clear
    assert_equal [1,1,2,3,5,8], @fibonacci.smallest_numbers(6)
    @fibonacci.clear_occurrences
    assert_equal [], @fibonacci.smallest_numbers(6)
    assert_equal [], PropertyOccurrence.find_all_by_property_id(0)
  end

  def test_metadata
    assert_equal 0, @loaded_property.knowledge_bound
    assert !@loaded_property.known?(10)
    assert @loaded_property.cool?
    @loaded_property.load_from_file("test/fixtures/evil.file")
    @loaded_property = Property.find(@loaded_property.id) # Clobber in-memory state
    assert_equal 20, @loaded_property.manual_knowledge_bound
    assert_equal 20, @loaded_property.knowledge_bound
    assert @loaded_property.known?(10)
    assert !@loaded_property.known?(11)
    assert !@loaded_property.known?(12)
    assert @loaded_property.known?(13)
    assert !@loaded_property.cool?
  end

  def test_known
    [ [ @fibonacci, 8 ],
      [ @square_free, 14 ],
      [ @prime, 19 ],
      [ @abundant, 24 ] ].each do |prop, bound|
      1.upto(bound) do |num|
        assert prop.known?(num)
      end
      assert !prop.known?(bound+1)
      assert !prop.known?(bound+2)
    end
    assert @apocalyptic_power.known?(14)
    assert !@apocalyptic_power.known?(15) # See fixtures
    assert @apocalyptic_power.known?(16)
  end

  def test_definition_parsing
    assert Property.find(:first, :conditions => ["adjective = ?", "amicable"]).nil?
    Property.load_definitions("test/fixtures/property_parsing.txt")
    amicable = Property.find(:first, :conditions => ["adjective = ?", "amicable"])
    assert_kind_of Property, amicable
    assert_equal "amicable numbers", amicable.plural_noun
    assert amicable.definition =~ /The number n is <i>amicable<\/i> if/
  end

  def test_definition_updating
    assert Property.find(:first, :conditions => ["adjective = ?", "amicable"]).nil?
    Property.load_definitions("test/fixtures/property_parsing.txt")
    amicable = Property.find(:first, :conditions => ["adjective = ?", "amicable"])
    assert_kind_of Property, amicable

    # Same file for now, just to check against stupid breakages
    Property.reload_definitions("test/fixtures/property_parsing.txt")
    amicable2 = Property.find(:first, :conditions => ["adjective = ?", "amicable"])
    assert_kind_of Property, amicable2
  end

end
