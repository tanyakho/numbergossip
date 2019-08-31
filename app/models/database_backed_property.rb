class DatabaseBackedProperty < ComputableProperty

  def initialize(plural_noun)
    @plural_noun = plural_noun
  end

  def test(n)
    Property.find_by_plural_noun(@plural_noun).test(n)
  end

  def count(bound)
    Property.find_by_plural_noun(@plural_noun).count(bound)
  end

  def knowledge_bound
    Property.find_by_plural_noun(@plural_noun).knowledge_bound
  end

  def next_after
    Property.find_by_plural_noun(@plural_noun).next_after
  end

  def last_before
    Property.find_by_plural_noun(@plural_noun).last_before
  end

end
