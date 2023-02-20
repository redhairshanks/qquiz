module PollException

  class GeneratedException < StandardError
    def initialize(msg)
      super(msg)
    end
  end

end