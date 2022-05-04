module ViewSpecHelpers
  module ControllerViewHelpers
    def current_c100_application
      raise 'Stub `current_c100_application` if you want to test the behavior.'
    end
  end

  def initialize_view_helpers(view)
    view.extend ControllerViewHelpers
  end
end
