module ArrayExtension
  def presence_join(separator = nil)
    reject(&:blank?).join(separator)
  end
end
