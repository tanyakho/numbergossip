require File.dirname(__FILE__) + '/../test_helper'
require 'number_gossip_controller'

# Re-raise errors caught by the controller.
class NumberGossipController; def rescue_action(e) raise e end; end

class NumberGossipControllerTest < ActionController::TestCase
  fixtures :properties, :property_occurrences, :unique_properties

  def setup
    @controller = NumberGossipController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index

    assert_response :success
    assert_template 'index'
    assert_nil assigns(:number)
    assert_nil assigns(:properties)
  end

  def test_cool_number
    get :index, :number => "6"

    assert_response :success
    assert_template 'index'
    assert_equal 6, assigns(:number)
    assert_not_nil assigns(:properties)

    assert_tag :tag => 'div', :attributes => {:id => 'cool'}
    assert_tag :tag => 'div', :attributes => {:id => 'boring'}
    # HTML tags in neighborhood rows should not be escaped
    assert_tag :tag => 'ul', :attributes => {:class => 'neighborhood_row'}
    assert_tag :tag => 'a', :attributes => {:class => 'number_link'},
               :content => '7'
  end

  def test_no_duplicate_properties
    get :index, :number => "1"

    assert_response :success
    assert_template 'index'
    props = assigns(:properties)
    props.each_with_index do |prop1, index|
      props[0...index].each { |prop2| assert !(prop1 == prop2) }
    end
  end

  def test_unique_display
    get :index, :number => "1"

    assert_equal [@multiplicative_identity], assigns(:unique_properties)
    assert_tag :tag => "div", :attributes => {:id => 'unique_properties'}, :descendant => /multiplicative identity/
    assert_no_tag /first number/
    # HTML tags in unique property definitions should not be escaped
    assert_tag :tag => "i", :content => 'the'
  end

  def test_cross_link
    get :index, :number => "4"

    assert_response :success
    assert_template 'index'
    # HTML tags in property definitions should not be escaped
    assert_tag :tag => 'a', :attributes => {:href => /square-free/},
               :content => /square-free/
  end

  def test_upper_bound
    get :index, :number => "11"

    assert !assigns(:unique_properties)
    assert !assigns(:properties)
    assert_no_tag :tag => "div", :attributes => {:id => 'unique_properties'}
    assert_tag :content => /sure 11 is a fine number/
  end

  def test_list
    get :list
    assert_response :success
    assert_tag :tag => 'div', :attributes => {:id => 'even_numbers'}
    assert_tag :tag => 'div', :attributes => {:id => 'fibonacci_numbers'}
    assert_tag :tag => 'div', :attributes => {:id => 'evil_numbers'}
    assert_tag :tag => 'div', :attributes => {:id => 'perfect_numbers'}
    # HTML tags in property definitions should not be escaped
    # This one occurs in the apocalyptic powers definition
    assert_tag :tag => 'sup', :content => 'n'
  end

  def test_status
    get :status
    assert_response :success
    assert_tag :content => /The primes are known up to 19/
    assert_tag :content => /The squares are computed/
    # Generated HTML tags should not be escaped
    assert_tag :tag => 'td', :attributes => {:class => 'fresh'},
               :content => /The unique properties are up to date/
    assert_tag :tag => 'td', :attributes => {:class => 'stale'},
               :content => /The primes are out of date/
  end

  def test_credits
    get :credits
    assert_response :success
    assert_tag :tag => 'li', :content => /Sergei Bernstein/
    # HTML tags in the credits should not be escaped
    assert_tag :tag => 'a',
               :attributes => {:href => 'http://www.knowltonmosaics.com/'},
               :content => /Ken Knowlton/
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
