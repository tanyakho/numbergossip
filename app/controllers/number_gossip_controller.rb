class NumberGossipController < ApplicationController

  include ERB::Util

  def index
    @cache_page = false
    if params[:number]
      @number = params[:number].to_f.to_i
      case
      when @number == 0 && !(params[:number] =~ /^[+-]?[.0-9]/)
        flash.now[:error] = "I only gossip about numbers, but if you want to know about #{h params[:number]}, I'm sure <a href='http://www.google.com'>Google</a> will enlighten you.".html_safe
      when @number < 1
        flash.now[:error] = "I'm sure #{@number} is a fine number, but I only like to talk about positive things."
      when @number >= Property.display_bound
        flash.now[:error] = "I'm sure #{@number} is a fine number, but I do not yet know any interesting gossip about numbers bigger than #{Property.display_bound - 1}."
      else
        if params[:number] == @number.to_s
          @cache_page = true
        end
        @properties = Property.properties_of(@number)
        @unique_properties = UniqueProperty.properties_of(@number)
      end
    end
  end

  def list
    @all_props = Property.order(adjective: :asc).to_a
  end

  def credits
    @submitters = ["Sergei Bernstein", "<a href=\"http://web.mit.edu/~axch/www/\">Alexey Radul</a>", "Sam Steingold", "Andy Baker", "John Kiehl", "Andy Pallotta", "Billy", "Jonathan Post", "David Bernstein", "Michael W. Ecker", "Carlo S&eacute;quin", "<a href=\"http://www.knowltonmosaics.com/\">Ken Knowlton</a>", "Qiaochu Yuan", "<a href=\"http://www.peterrowlett.net\">Peter Rowlett</a>", "Dan MacKinnon", "Nick McGrath", "Sabine Stoecker", "Tamas Fleischer", "Dan D'Eramo"]
    @submitters = @submitters.map do |x| x.html_safe end
    @checkers = ["Sergei Bernstein", "Alexey Radul", "Max Alekseyev", "Jaap Spies"]
  end

  def status
    @all_props = Property.order(adjective: :asc).to_a
  end

  def update
    case params[:id]
    when /unique/i then UniqueProperty.parse_working_file
    when /rebuild/i then Property.rebuild_database
    when /definitions/i then Property.reload_definitions
    when /all/i then Property.reload_stale_occurrences
    else
      Property.find(params[:id].to_i).load_from_file
    end
    redirect_to :action => "status"
  end

  # TODO Perhaps migrate to caching more modern than Rails 3,
  # and flush actionpack-page_caching from the Gemfile
  after_action :cache_number_page, :only => :index
  before_action :expire_number_pages, :only => [:update]

  private
  def cache_number_page
    if @cache_page
      cache_page(response.body, :number => @number)
    end
  end

  def expire_number_pages
    expire_page(:controller => "number_gossip", :action => "index")
    FileUtils.rm_f(Dir.glob(RAILS_ROOT + '/public/*[0-9].html'))
  end
end
