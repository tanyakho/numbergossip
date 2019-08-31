# A segment of the db/properties/definitions.txt file corresponding
# to one property definition.  Depends on that file's format.
class DefinitionParser
  def initialize(string)
    @segment = string
  end

  def new_property
    Property.new({ :adjective => main_adjective, 
                   :alternate_adjective => alternate_adjective, 
                   :plural_noun => plural_noun, 
                   :definition => definition })
  end

  def find_property
    Property.find_by_plural_noun(plural_noun)
  end

  def update_property!
    property = find_property
    if property
      property.name = Name.new(main_adjective, alternate_adjective, plural_noun)
      property.definition = definition
    else
      property = new_property
    end
    property.save!
  end

  def first_ten
    @segment.match(/<i>First ten( \(known\))?:<\/i>\s*(.*?)<p>There are/m)[2].split(/,\s*/).map {|str| str.to_i}
  end

  def plural_noun
    @segment.match(/<p>There are ([0-9]+|no)( different)? (.+?) below 10,000/)[3].strip
  end

 private
  def adjectives    
    @segment.match(/^<h3>\s*<a.*?>\s*(.+?)\s*<\/a>\s*<\/h3>/)[1].strip
  end

  def main_adjective
    adjectives.split(/[()]/)[0].strip
  end

  def alternate_adjective
    answer = adjectives.split(/[()]/)[1]
    if answer then
      answer.strip
    else
      nil
    end
  end

  def definition
    @segment.match(/<i>Definition:<\/i>(.*?)(\s*<\/?p>\s*)*<i>First ten/m)[1].strip.gsub("<p>", "</p><p>").gsub(/<a href\s*=\s*"#(.*?)">(.*?)<\/a>/, '[[\1][\2]]')
  end

end
