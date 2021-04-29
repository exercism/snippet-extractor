module SnippetExtractor
  class ExtractSnippet
    include Mandate
    include Extended

    initialize_with :code, :language

    def call
      processed_lines[0...10].join
    end

    private
    def processed_lines
      return ExtendedExtractor.(code, ignore_list).join if ignore_list[0].include? "!e"
      
      lines.drop_while do |line|
        naked_line = line.strip
        next true if naked_line.empty?
        next true if ignore_list.any? { |ignore| naked_line.start_with?(ignore) }

        false
      end
    rescue Errno::ENOENT
      lines
    end

    def lines
      code.lines
    end

    memoize
    def ignore_list
      slug = language.to_s.gsub(/[^a-z0-9-]/, '')
      File.read(File.expand_path("../../languages/#{slug}.txt", __FILE__)).lines.map(&:rstrip)
    end
  end
end
