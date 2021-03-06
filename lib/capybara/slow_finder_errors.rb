require 'capybara'
module Capybara
  class SlowFinderError < CapybaraError; end

  module Node
    class Base
      def synchronize_with_timeout_error(seconds=Capybara.default_wait_time, options = {}, &block)
        start_time = Time.now
        synchronize_without_timeout_error(seconds, options, &block)
      rescue Capybara::ElementNotFound => e
        if Time.now-start_time > seconds
          raise SlowFinderError
        end
      end
      alias_method :synchronize_without_timeout_error, :synchronize
      alias_method :synchronize, :synchronize_with_timeout_error
    end
  end
end
