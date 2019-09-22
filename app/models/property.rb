## The main model for (non-Unique) properties of numbers.  This tracks
## the meta-information about the various properties, such as their
## names, and is also ultimately responsible for producing answers to
## the questions that views ask about what numbers have various
## properties.
##
## By default, properties are assumed to be backed by the database.
## However, if a PropertyComputer object can be found for the
## property, and that object has a method to address the desired
## question, that will be invoked instead to do the computation online
## in the app server instead of looking it up from the database
## server.
##
## This model also includes machinery for reading files in
## db/properties/*.file and dumping their contents into the database.
class Property < ActiveRecord::Base
  composed_of :name, :mapping => [["adjective", "adjective"], ["alternate_adjective", "alternate_adjective"], ["plural_noun", "plural_noun"]]
  has_many :property_occurrences, :order => "number", :dependent => :destroy
  has_many :knowledge_gaps, :dependent => :destroy

  def self.properties_of(number)
    props_from_db = PropertyOccurrence.find_all_by_number(PropertyOccurrence.zero_pad(number)).map {|occurrence| occurrence.property}.uniq
    tested_props = Property.find(:all).select {|prop| prop.testable? && prop.test(number)}
    (props_from_db + tested_props).uniq.sort {|prop1, prop2| prop1.name.adjective.downcase <=> prop2.name.adjective.downcase}
  end

  def computer
    if PropertyComputer.const_defined? name.computer_name
    then PropertyComputer.const_get name.computer_name
    else nil
    end
  end

  def smallest_numbers(count)
    next_after(0, count)
  end

  # Exclusive
  def count(bound = Property.display_bound)
    if count_computable?
      computer.count(bound)
    else
      PropertyOccurrence.count_by_sql("SELECT COUNT(DISTINCT number) FROM property_occurrences WHERE property_id = #{id} and number < '#{PropertyOccurrence.zero_pad(bound)}'")
    end
  end

  # Exclusive
  def count_with_multiplicity(bound = Property.display_bound)
    # So, what do count and count with multiplicity do for computable, repeated properties?
    if count_computable?
      computer.count(bound)
    else
      property_occurrences.count(:conditions => [ "number < ?", PropertyOccurrence.zero_pad(bound) ])
    end
  end

  def duplicates_present?(bound = Property.display_bound)
    count_with_multiplicity(bound) != count(bound)
  end

  def cool?
    count(Property.display_bound) < Math.sqrt(Property.display_bound)
  end

  def test(number)
    if testable?
      computer.test(number)
    else
      property_occurrences.find(:all, :conditions => [ "number = ?", PropertyOccurrence.zero_pad(number) ]).length > 0
    end
  end

  def known?(number)
    meta_knowledge.known?(number)
  end

  def memorized?
    # What I really mean is "Is this a PrefixEnumeratedProperty whose
    # data came from a file?", but as of r259 they all are, and the
    # precise question is more difficult to answer.
    testable? and computer.kind_of? PrefixEnumeratedProperty
  end

  def testable?
    computer.respond_to?(:test)
  end

  def count_computable?
    computer.respond_to?(:count)
  end

  def knowledge_bound_computable?
    computer.respond_to?(:knowledge_bound)
  end

  # Inclusive
  def knowledge_bound
    if knowledge_bound_computable?
      computer.knowledge_bound
    else
      meta_knowledge.knowledge_bound
    end
  end

  # Exclusive of base
  def next_after(base, count = Property.neighbor_width)
    if computer.respond_to? :next_after
      computer.next_after(base, count)
    else
      property_occurrences.find(:all, :conditions => [ "number > ?", PropertyOccurrence.zero_pad(base) ], :limit => count).map { |occurrence| occurrence.number }
    end
  end

  # Exclusive of base
  def last_before(base, count = Property.neighbor_width)
    if computer.respond_to? :last_before
      computer.last_before(base, count)
    else
      bound = PropertyOccurrence.zero_pad(base)
      PropertyOccurrence.where("property_id = ? AND number < ?", id, bound).last(count).map { |occurrence| occurrence.number }
    end
  end

  # How many times does this number occur
  # in this property?
  def number_of_repetitions(number)
    if computer.respond_to? :number_of_repetitions
      computer.number_of_repetitions(number)
    else
      property_occurrences.count(:conditions => [ "number = ?", PropertyOccurrence.zero_pad(number) ])
    end
  end

  def meta_knowledge
    @meta_knowledge ||= MetaKnowledge.new(self)
  end

  def to_s
    "The #{name.plural_noun}"
  end

  # Exclusive
  def self.display_bound
    if ::Rails.env.test?
      10
    else
      10000
    end
  end

  def self.neighbor_width
    3
  end

  def fully_known?
    meta_knowledge.prefix_fully_known?(10)
  end

  def clear_occurrences
#    property_occurrences.clear doesn't seem to clean up the occurrences correctly.
    PropertyOccurrence.delete_all "property_id = #{id}"
    self.occurrences_updated_at = Time.now
    property_occurrences(true) # force refresh
  end

  def add_occurrences(numbers)
    property_occurrences << ( numbers.map { |number| PropertyOccurrence.new(:number => number) } )
    self.occurrences_updated_at = Time.now
    save!
  end

  def set_occurrences(numbers)
    clear_occurrences
    add_occurrences(numbers)
  end

  # Do I want to clone the above?  Do I want to merge these into
  # one method that does it all (for consistent tracking)?
  def set_gaps(gaps)
    KnowledgeGap.delete_all "property_id = #{id}"
    knowledge_gaps << ( gaps.map { |number| KnowledgeGap.new(:number => number) } )
    save!
  end

  # The below deals with file-based property storage.
  # First we deal with the occurrences of individual properties.
  def default_file_name
    # Avoid relative directory paths
    File.dirname(__FILE__) + "/../../" + "db/properties/" + name.file_name
  end

  def occurrences_up_to_date?(filename = default_file_name)
    occurrences_updated_at && File.exist?(filename) && occurrences_updated_at > File.new(filename).mtime
  end

  def self.parse_property_file(filename)
    if File.readable?(filename)
      numbers, gaps, bounds = [], [], []
      File.open(filename) do |file| file.each do |line|
          case line
          when /^\d+/ then numbers.push line.to_i
          when /^\?(\d+)/ then gaps.push $1.to_i
          when /^~(\d+)/ then bounds.push $1.to_i
          end
        end end
      yield numbers, gaps, bounds
    end
  end

  def load_from_file(filename = default_file_name)
    Property.parse_property_file(filename) do |numbers, gaps, bounds|
      set_occurrences(numbers)
      set_gaps(gaps)
      self.manual_knowledge_bound = bounds.max || 0
      save!
    end
  end

  def self.all_occurrences_up_to_date?
    Property.find(:all).inject(true) { |run, prop| run && (prop.testable? || prop.occurrences_up_to_date?) }
  end

  def self.reload_stale_occurrences
    Property.find(:all).select { |prop| !prop.occurrences_up_to_date? }.each { |prop| prop.load_from_file }
  end

  # Then we deal with the property definitions as a group.
  def self.default_definitions_file
    # Avoid relative directory paths
    File.dirname(__FILE__) + "/../../" + "db/properties/definitions.txt"
  end

  def self.definitions_up_to_date?(filename = Property.default_definitions_file)
    Property.find(:all).each do |prop|
      if !prop.updated_at || prop.updated_at < File.new(filename).mtime
        return false
      end
    end
    if Property.count > 0
      true
    else
      false
    end
  end

  def self.load_definitions(filename = Property.default_definitions_file)
    File.open(filename) { |f| f.read.split("\n\n").each { |segment| Property.parse_definition(segment) } }
  end

  def self.parse_definition(string)
    DefinitionParser.new(string).new_property.save!
  end

  def self.parse_occurrences_from_definition_file(filename = Property.default_definitions_file)
    File.open(filename) do |f| 
      f.read.split("\n\n").each do |segment|
        parser = DefinitionParser.new(segment)
        property = parser.find_property
        if !property
          $stderr.puts parser
          $stderr.puts parser.plural_noun
        end
        if property.count <= 10
          property.set_occurrences(parser.first_ten)
        end
        :done
      end
    end
  end

  def self.reload_definitions(filename = Property.default_definitions_file)
    File.open(filename) { |f| f.read.split("\n\n").each { |segment| Property.reparse_definition(segment) } }
  end

  def self.reparse_definition(string)
    DefinitionParser.new(string).update_property!
  end

  def self.rebuild_database
    Property.transaction do
      Property.destroy_all
      Property.load_definitions
      Property.find(:all).each { |prop| prop.load_from_file }
      Property.parse_occurrences_from_definition_file
    end
  end
end
