module Steps
  module OtherChildren
    class NamesController < Steps::OtherChildrenStepController
      include NamesCrudStep
    end
  end
end
