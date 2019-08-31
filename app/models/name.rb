class Name
  attr_reader :adjective, :alternate_adjective, :plural_noun
  def initialize(adjective, alternate_adjective, plural_noun)
    @adjective = adjective
    @alternate_adjective = alternate_adjective
    @plural_noun = plural_noun
  end

  def segment_heading
    if alternate_adjective
      adjective.capitalize + " (" + alternate_adjective.capitalize + ")"
    else
      adjective.capitalize
    end
  end

  def anchor
    plural_noun.tr(" ", "_").downcase
  end

  def file_name
    plural_noun.tr(" ", "_").downcase + ".file"
  end

  def computer_name
    adjective.tr(" -", "__").camelize.to_sym
  end

end
