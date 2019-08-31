require File.dirname(__FILE__) + '/../test_helper'

class DefinitionParserTest < Test::Unit::TestCase

  def setup
    Property.load_definitions("test/fixtures/definitions.txt")
  end

  def teardown
    Property.find(:all).each {|prop| prop.destroy}
  end

  def test_smoke
  end

  def test_definition
    @carmichael = Property.find_by_adjective("Carmichael")
    assert_kind_of Property, @carmichael
    assert_equal "Carmichael", @carmichael.name.adjective
    assert_nil @carmichael.name.alternate_adjective
    assert_equal "Carmichael numbers", @carmichael.name.plural_noun
    assert_equal "The composite integer n is a <i>Carmichael number</i> if <span class=\"nowrap\">b<sup>n</sup> = b (mod n)</span> for every integer b, \nwhich is relatively prime with n.\n</p><p>\nCarmichael numbers behave like prime numbers with respect to the most useful primality test, that is they pretend to be prime.", @carmichael.definition
  end

  def test_alternate_adjective
    @smith = Property.find_by_adjective("Smith")
    assert_equal "joke", @smith.name.alternate_adjective
    @automorphic = Property.find_by_adjective("automorphic")
    assert_equal "curious", @automorphic.name.alternate_adjective
    assert_equal "Automorphic (Curious)", @automorphic.name.segment_heading
  end

end
