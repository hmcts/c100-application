class SplitAddress < Virtus::Attribute
  TOKEN_SEPARATOR = '|'.freeze

  def coerce(value)
    tokens = value.to_s.split(TOKEN_SEPARATOR)
    return nil if tokens.empty?

    {
      address_line_1: tokens[0],
      address_line_2: tokens[1],
      address_line_3: tokens[2],
      town: tokens[3],
      country: tokens[4],
      postcode: tokens[5],
    }
  end
end
