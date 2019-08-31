class ComplementaryProperty < ComputableProperty

  include TestableProperty

  def initialize(*complements)
    @complements = complements
  end

  def test(n)
    known?(n) and not @complements.inject(false) { |run, prop| run || prop.test(n) }
  end

  def count(bound)
    @complements.inject(bound - 1) { |run, prop| run - prop.count(bound) }
  end

  def knowledge_bound
    @complements.map { |prop| prop.knowledge_bound }.min
  end

  def known?(n)
    n <= knowledge_bound
  end

end
