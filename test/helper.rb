$:.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'test/unit/assertions'
require 'reality/naming'

module Reality
  module Naming
    class << self
      def reset
        @pluralization_rules = nil
      end
    end
  end
end

class Reality::Naming::TestCase < Minitest::Test
  include Test::Unit::Assertions

  def setup
    Reality::Naming.reset
  end
end
