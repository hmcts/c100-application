module Steps
  module Children
    class NamesController < Steps::ChildrenStepController
      include NamesCrudStep
    end
  end
end
