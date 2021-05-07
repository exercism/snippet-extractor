module SnippetExtractor
  module Basic
    class Extract
      include Mandate

      initialize_with :code, :ignore_list

      def call
        extracted_lines = lines.drop_while do |line|
          naked_line = line.strip

          next true if naked_line.empty?
          next true if ignore_list.any? { |ignore| naked_line.start_with?(ignore) }

          false
        end

        extracted_lines[0...10]
      end

      def lines
        code.lines
      end
    end
  end
end
