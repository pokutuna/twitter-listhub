require 'logger'

require 'model/twitter'

module Model
  def self.logger
    @logger ||= Logger.new($stderr)
  end
end
