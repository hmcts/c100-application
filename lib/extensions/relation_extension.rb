# Note: backported from Rails 6
# Refer to https://github.com/rails/rails/pull/31989

module RelationExtension
  #:nocov:
  def create_or_find_by!(attributes, &block)
    transaction(requires_new: true) { create!(attributes, &block) }
  rescue ActiveRecord::RecordNotUnique
    find_by!(attributes)
  end
  #:nocov:
end
