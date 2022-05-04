module C100
  module Test
    module PageObjects
      # @return [C100::Test::PageObjects::CookieManagementPage]
      def cookie_management_page
        CookieManagementPage.new
      end

      # @return [C100::Test::PageObjects::AnyPage] The special 'any' page that can access
      #   elements that are common to all
      def any_page
        AnyPage.new
      end
    end
  end
end

World(C100::Test::PageObjects)
