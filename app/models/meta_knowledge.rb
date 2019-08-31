class MetaKnowledge

  def initialize(property)
    @property = property
  end

  def knowledge_bound
    if @property.last_occurrence
      [ @property.last_occurrence.number, @property.manual_knowledge_bound || 0 ].max
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
      @property.knowledge_gaps.find(:all, :conditions => [ "number = ?", KnowledgeGap.zero_pad(number) ]).length == 0
  end

end
