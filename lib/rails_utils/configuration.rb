module RailsUtils
  class Configuration
    attr_accessor :selector_format

    def initialize
      @selector_format = :underscored
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end
end
