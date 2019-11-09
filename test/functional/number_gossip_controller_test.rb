require File.dirname(__FILE__) + '/../test_helper'
require 'number_gossip_controller'

# Re-raise errors caught by the controller.
class NumberGossipController; def rescue_action(e) raise e end; end

class NumberGossipControllerTest < ActionController::TestCase
  fixtures :properties, :property_occurrences, :unique_properties

  def test_index
    get :index

    assert_response :success
    # Check we are on the front page and asking for a number
    assert_select "form > div#form > input#number"
    # Check that there are no properties
    assert_select "div#cool", false
    assert_select "div#boring", false
  end

  def test_cool_number
    get :index, params: {:number => "6"}

    assert_response :success
    assert_select "form > div#form > input#number" do
      assert_select "[name=?]", "number"
      assert_select "[value=?]", "6"
    end

    assert_select "div#cool"
    assert_select "div#boring"
    # HTML tags in neighborhood rows should not be escaped
    assert_select "ul.neighborhood_row"
    assert_select "a.number_link", {text: '7'}
  end

  def test_unique_display
    get :index, params: {:number => "1"}

    assert_select "div#unique_properties" do
      assert_select "li", /multiplicative identity/
    end
    # HTML tags in unique property definitions should not be escaped
    assert_select "i", "the"
  end

  def test_cross_link
    get :index, params: {:number => "4"}

    assert_response :success
    # HTML tags in property definitions should not be escaped
    assert_select "a[href='#square-free']", /square-free/
  end

  def test_upper_bound
    get :index, params: {:number => "11"}

    assert_select "form > div#form > input#number"
    assert_select "div#unique_properties", false
    assert_select "div#cool", false
    assert_select "div#boring", false
    assert_select "div.error", /sure 11 is a fine number/
  end

  def test_list
    get :list
    assert_response :success
    assert_select "div#even_numbers"
    assert_select "div#fibonacci_numbers"
    assert_select "div#evil_numbers"
    assert_select "div#perfect_numbers"
    # HTML tags in property definitions should not be escaped
    # This one occurs in the apocalyptic powers definition
    assert_select "sup", "n"
  end

  def test_status
    get :status
    assert_response :success
    assert_select "td", /The primes are known up to 19/
    assert_select "td.fresh", /The squares are computed/
    # Generated HTML tags should not be escaped
    assert_select "td.fresh", /The unique properties are up to date/
    assert_select "td.stale", /The primes are out of date/
  end

  def test_credits
    get :credits
    assert_response :success
    assert_select "li", /Sergei Bernstein/
    # HTML tags in the credits should not be escaped
    assert_select "a[href='http://www.knowltonmosaics.com/']", /Ken Knowlton/
  end

  def assert_routes_number(path, number)
    assert_routing "/index/#{path}", :controller => 'number_gossip', :action => 'index', :number => number
  end
  
  def assert_routes_page(path, page)
    assert_routing "/#{path}", :controller => 'number_gossip', :action => page
  end
  
  def test_routing
    assert_routes_number "3", "3"
    assert_routes_number "47", "47"
    assert_routes_number "490907", "490907"
    assert_routes_number "-9", "-9"
    assert_routes_page "list", "list"
  end
end
