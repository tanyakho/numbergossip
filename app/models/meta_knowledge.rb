class MetaKnowledge

  def initialize(property)
    @property = property
  end

  def knowledge_bound
    if @property.property_occurrences.last
      [ @property.property_occurrences.last.number,
        @property.manual_knowledge_bound || 0 ].max
    else
      @property.manual_knowledge_bound || 0
    end
  end

  def prefix_fully_known?(count)
    # TODO hack alert
    @property.name.adjective != 'sociable' and @property.name.adjective != 'aspiring'
  end

  def known?(number)
    number <= @property.knowledge_bound and
      @property
      .knowledge_gaps
      .where("number = ?", KnowledgeGap.zero_pad(number))
      .count == 0
  end

end
