require File.dirname(__FILE__) + '/../test_helper'

class PropertyOccurrenceTest < Test::Unit::TestCase
  fixtures :property_occurrences

  def setup
    @property_occurrence = PropertyOccurrence.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of PropertyOccurrence,  @property_occurrence
  end
end
