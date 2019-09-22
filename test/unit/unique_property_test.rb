require File.dirname(__FILE__) + '/../test_helper'

class UniquePropertyTest < ActiveSupport::TestCase
  fixtures :unique_properties

  def setup
    @unique_property = UniqueProperty.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of UniqueProperty,  @unique_property
  end

  def test_display_choice
    assert @multiplicative_identity.display?
    assert !@first_number.display?
  end

  def test_metadata_parsing
    meta = UniquePropertyMetadata.parse_metadata([])
    assert_equal "no", meta.display
    assert_equal "unknown", meta.interest
    assert_equal "unknown", meta.truth
    assert_equal "unknown", meta.uniqueness
  end

  def test_metadata_assignment
    @unique_property.metadata = UniquePropertyMetadata.parse_metadata([])
    assert_equal "no", @unique_property.metadata.display
    assert_equal "unknown", @unique_property.metadata.interest
    assert_equal "unknown", @unique_property.metadata.truth
    assert_equal "unknown", @unique_property.metadata.uniqueness
    @unique_property.save!
    refetched = UniqueProperty.find(1)
    assert_equal "no", refetched.metadata.display
    assert_equal "unknown", refetched.metadata.interest
    assert_equal "unknown", refetched.metadata.truth
    assert_equal "unknown", refetched.metadata.uniqueness
  end

  def test_create_with_metadata
    up = UniqueProperty.create!(:number => 2, :statement => "Two is the oddest prime.", :metadata => UniquePropertyMetadata.parse_metadata(["*"]))
    assert_equal 2, up.number
    assert_equal "Two is the oddest prime.", up.statement
    assert_equal "yes", up.metadata.display
    assert_equal "yes", up.metadata.interest
    assert_equal "yes", up.metadata.truth
    assert_equal "yes", up.metadata.uniqueness

    refetched = UniqueProperty.find(up.id)
    assert_equal 2, refetched.number
    assert_equal "Two is the oddest prime.", refetched.statement
    assert_equal "yes", refetched.metadata.display
    assert_equal "yes", refetched.metadata.interest
    assert_equal "yes", refetched.metadata.truth
    assert_equal "yes", refetched.metadata.uniqueness
  end

  def test_parsing
    assert_equal 2, UniqueProperty.count
    UniqueProperty.parse_working_file("test/fixtures/unique_property_parsing.txt")
    assert_equal 98, UniqueProperty.count
    line_1 = UniqueProperty.find(:first)
    assert_equal 0, line_1.number
    assert_equal "is the only integer that is neither positive not negative", line_1.statement
    assert !line_1.display?
    assert_equal "no", line_1.metadata.display
    assert_equal "unknown", line_1.metadata.interest
    assert_equal "unknown", line_1.metadata.truth
    assert_equal "unknown", line_1.metadata.uniqueness
  end
end
