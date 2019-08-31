class UniquePropertyMetadata
  attr_reader :display, :interest, :truth, :uniqueness
  def initialize(display, interest, truth, uniqueness)
    @display = display
    @interest = interest
    @truth = truth
    @uniqueness = uniqueness
  end

  def display?
    @display.eql?("yes")
  end

  def self.parse_metadata(markers)
    case markers
    when []
      UniquePropertyMetadata.new("no", "unknown", "unknown", "unknown")
    when ["*"]
      UniquePropertyMetadata.new("yes", "yes", "yes", "yes")
    when ["NT"]
      UniquePropertyMetadata.new("no", "don't care", "no", "don't care")
    when ["NU"]
      UniquePropertyMetadata.new("no", "don't care", "yes", "no")
    when ["NS"]
      UniquePropertyMetadata.new("no", "not sure", "yes", "yes")
    when ["NVI"]
      UniquePropertyMetadata.new("no", "no", "yes", "yes")
    when ["U??"]
      UniquePropertyMetadata.new("no", "yes", "unknown", "unknown")
    when ["??"], ["S??"]
      UniquePropertyMetadata.new("no", "yes", "unknown", "unknown")
    when ["NS", "??"], ["NS", "S??"], ["NS", "U??"], ["??", "NS"], ["S??", "NS"], ["U??", "NS"]
      UniquePropertyMetadata.new("no", "not sure", "unknown", "unknown")
    when ["NVI", "??"], ["NVI", "S??"], ["??", "NVI"], ["S??", "NVI"]
      UniquePropertyMetadata.new("no", "no", "unknown", "unknown")
    else
      raise "Metadata parsing failed: #{markers.join(', ')}"
    end
  end
end
