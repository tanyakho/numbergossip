class UniqueProperty < ApplicationRecord
  composed_of :metadata, :class_name => "UniquePropertyMetadata", :mapping => [["display", "display"], ["interest", "interest"], ["truth", "truth"], ["uniqueness", "uniqueness"]]

  def self.properties_of(number)
    where("number = ?", number).to_a.select {|prop| prop.display?}
  end

  def display?
    metadata.display?
  end

  def self.default_working_file
    # Avoid relative directory paths
    File.dirname(__FILE__) + "/../../" + "db/properties/uniqueWorking.txt"
  end

  def self.definitions_up_to_date?(filename = UniqueProperty.default_working_file) #***!
    UniqueProperty.all.each do |prop|
      if !prop.updated_at || prop.updated_at < File.new(filename).mtime
        return false
      end
    end
    if UniqueProperty.count > 0
      true
    else
      false
    end
  end

  def self.parse_working_file(filename = UniqueProperty.default_working_file)
    UniqueProperty.transaction do
      delete_all
      File.open(filename) do |f|
        current_number = nil
        f.each do |line|
          case line
          when /^\s*$/
            # Skip blanks
          when /^\s*([0-9]+)\s*$/ # A number on a line by itself starts the section for a new number
            current_number = $1.to_i
          when /^==== STOP PARSING ====/
            # current_number = nil
            return
          else
            parse_line(line, current_number) if current_number
          end
        end
      end
    end
  end

  def self.parse_line(line, current_number)
    markers = []
    while line =~ /^(NVI|NS|NT|NU|\*|\?\?|[sS]\?\?|U\?\?) (.+)$/ do
      markers.push $1
      line = $2
    end
    statement_hash = UniqueProperty.parse_statement(line)
    UniqueProperty.create(statement_hash.merge({ :number => current_number, :metadata => UniquePropertyMetadata.parse_metadata(markers) }))
  end

  def self.parse_statement(statement_with_comments)
    case statement_with_comments
    when /^(.*);(.*?)$/
      { :statement => $1.strip,
        :comments => $2.strip }
    when /^(.*?)\[(.*?)\](.*)$/
      { :statement => $1.strip,
        :source => "[" + $2.strip + "]",
        :comments => $3.strip }
    when /^(.*?)(\([^()]*([Ww]iki|[sS]ubmitted|[Cc]ontributed|[Pp]roved|[Cc]hecked|[uU][nN]iqu?e?ness)[^()]*\).*)$/
      { :statement => $1.strip,
        :comments => $2.strip }
    else
      { :statement => statement_with_comments.strip }
    end
  end
end
