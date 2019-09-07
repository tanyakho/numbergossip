require File.dirname(__FILE__) + '/../test_helper'

class PropertyTest < ActiveRecord::TestCase
  fixtures :properties

  def teardown
    Property.find(:all).each {|prop| prop.destroy}
  end

  def test_load_from_file
    assert_equal [], @loaded_property.smallest_numbers(300)
    elapsedSeconds = Benchmark::realtime do 
      @loaded_property.load_from_file("test/fixtures/performance/evil.file")
    end
    assert elapsedSeconds < 75.0, "Actually took #{elapsedSeconds} seconds."
    assert_equal 3, @loaded_property.smallest_numbers(300)[0]
    assert_equal 198, @loaded_property.smallest_numbers(300)[98]
  end

  def test_parsing
    Property.destroy_all
    Property.load_definitions("test/fixtures/definitions.txt")
    Property.parse_occurrences_from_definition_file("test/fixtures/definitions.txt")
    assert_equal 47, Property.count
    Property.find(:all).each do |prop|
      assert_not_nil prop.name.adjective
      assert_not_nil prop.name.plural_noun
      assert_not_nil prop.definition
      assert_equal 10, prop.smallest_numbers(10).length, prop.name.adjective
    end
    @carmichael = Property.find_by_adjective("Carmichael")
    assert_equal [561, 1105, 1729, 2465, 2821, 6601, 8911, 10585, 15841, 29341], @carmichael.smallest_numbers(10)
  end

end
