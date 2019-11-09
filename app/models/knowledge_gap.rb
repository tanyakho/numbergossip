class KnowledgeGap < ApplicationRecord
  belongs_to :property

# For dealing with numbers that are too big for the database to keep as ints.
# Requires schema change
  def number
    read_attribute("number").to_i
  end

  def number=(number)
    write_attribute("number", KnowledgeGap.zero_pad(number))
  end

# private
  def self.zero_pad(number)
    "0" * (100 - number.to_s.length) + number.to_s
  end
end
