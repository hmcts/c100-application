Dir[File.join(Rails.root, 'lib', 'extensions', '*.rb')].each(&method(:require))

class Array
  include ArrayExtension
end

class String
  include StringExtension
end

module ActiveRecord::Querying
  include RelationExtension
end
