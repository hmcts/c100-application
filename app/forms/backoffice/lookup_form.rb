module Backoffice
  class LookupForm
    include ActiveModel::Model

    attr_accessor :reference_code, :email_address

    validates_presence_of :reference_code
    validates :reference_code, c100_reference_code: true, allow_blank: true

    # Email is optional, and in some places we don't even ask for it
    validates :email_address, email: true, allow_blank: true

    def initialize(*args)
      super

      # It is very common to copy&paste, introducing some extraneous spacing.
      # In order to reduce this silly mistake, we pro-actively remove blanks,
      # instead of returning no results or even worse, an error.
      #
      @reference_code.try(:strip!)
      @reference_code.try(:upcase!)
      @email_address.try(:strip!)
    end
  end
end
