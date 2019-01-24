# frozen_string_literal: true

require "shellwords"

module SimpleTextExtract
  module FormatExtractor
    class Base
      attr_reader :file

      def initialize(file)
        @file = file
      end

      def extract
      end

      def missing_dependency?(command)
        dependency = `bash -c 'command -v #{command}'`
        dependency.nil? || dependency.empty?
      end
    end
  end
end
