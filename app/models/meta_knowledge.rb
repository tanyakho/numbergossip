class MetaKnowledge

  def initialize(property)
    @property = property
  end

  def knowledge_bound
    the_last = @property.property_occurrences.order(number: :asc).last
    if the_last
      [ the_last.number, @property.manual_knowledge_bound || 0 ].max
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
