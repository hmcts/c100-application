class Solicitor < ApplicationRecord
  include PersonWithAddress

  belongs_to :c100_application
end
