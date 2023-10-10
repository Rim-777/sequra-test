# frozen_string_literal: true

module Utilities
  module BaseUtility
    module ClassMethods
      def call(*args, **kwargs)
        new(*args, **kwargs).call
      end
    end

    def self.prepended(base)
      # See https://dry-rb.org/gems/dry-initializer/3.0/skip-undefined/
      base.extend Dry::Initializer[undefined: false]
      base.extend ClassMethods
    end

    def initialize(*args, **kwargs)
      super(*args, **kwargs)
      @errors = []
    end

    def call
      self
    end
  end
end
