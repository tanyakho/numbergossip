module NumberGossipHelper

  def interpolate_property_links(string)
    string.gsub(/\[\[(.*?)\]\[(.*?)\]\]/) { |match| link_to $2, :action => "list", :anchor => Property.find_by_adjective($1).name.anchor }
  end

  def first_ten_label(property)
    if property.fully_known?
      "First ten:"
    else
      "First ten (known):"
    end
  end

  def count_words(property)
    (property.count > 0 ? property.count.to_s : "no") + 
      (property.fully_known? ? "" : " known")
  end

  def breakpoints(num_columns, num_items)
    base_len = num_items / num_columns
    leftovers = num_items % num_columns
    (0...num_columns).map { |i| base_len * (i + 1) + (i < leftovers ? i + 1 : leftovers) }
  end

  def freshness_row(freshness, name, update_id, options = {})
    options[:update] ||= "Update"
    options[:update_anyway] ||= options[:update] + " Anyway"
    unless options.has_key? :offer_to_update_anyway
      options[:offer_to_update_anyway] = true
    end
    if freshness
      button_html = if options[:offer_to_update_anyway]
                      button_to(options[:update_anyway], :action => "update", :id => update_id) + " #{options[:note]}"
                    else
                      ""
                    end
      ("<td width='50%' class='fresh'>The #{name} are up to date</td><td>" + button_html + "</td>").html_safe
    else
      ("<td width='50%' class='stale'>The #{name} are out of date</td><td>" + button_to(options[:update], :action => "update", :id => update_id) + " #{options[:note]}</td>").html_safe
    end
  end

  def knowledge_report(property, target_level = Property.display_bound)
    knowledge_level = if property.knowledge_bound < target_level
                        "known_ill"
                      elsif property.next_after(target_level, Property.neighbor_width).length < Property.neighbor_width
                        "known_ok"
                      else
                        "known_well"
                      end
    ("<td class=\"#{knowledge_level}\"> &nbsp; The #{property.plural_noun} are known up to #{property.knowledge_bound}.</td>").html_safe
  end

  def number_link(num)
    if num < Property.display_bound
      (link_to num.to_s, { :controller => "number_gossip", :action => "index", :number => num.to_s, :use_route => :number_page }, { :class => "number_link" }).html_safe
    else
      num.to_s
    end
  end

  def neighborhood_row(property, number)
    width = Property.neighbor_width
    low_neighbors = property.last_before(number, width + 1).map { |num| number_link num }
    low_neighbors[0] = "..." if low_neighbors.length == width + 1

    # TODO This contains a subtle bug.  The next_after method of a
    # PrefixEnumeratedProperty can produce trailing nils in the array,
    # because the next_after of FormulaProperty calls generate, but
    # the generate of PrefixEnumeratedProperty can return nil.  This
    # whole problem might be a consequence of treating a
    # PrefixEnumeratedProperty as a FormulaProperty.
    high_neighbors = property.next_after(number, width).map { |num| number_link num }
    high_neighbors += [ "..." ] # Assume that all properties reach to infinity
    
    current = [ "<strong>#{number}</strong>" ] * property.number_of_repetitions(number)

    "<ul class=\"neighborhood_row\"><li>" + (low_neighbors + current + high_neighbors).join(",</li> <li>") + "</li></ul>"
  end

end
