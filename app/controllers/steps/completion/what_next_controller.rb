module Steps
  module Completion
    class WhatNextController < Steps::CompletionStepController
      include CompletionStep

      def show
        @court = court_from_screener_answers
        @local_court = local_court
      end
    end
  end
end
