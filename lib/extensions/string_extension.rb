module StringExtension
  def true?
    /(true|t|yes|y|1)$/i.match(to_s).present?
  end
end
