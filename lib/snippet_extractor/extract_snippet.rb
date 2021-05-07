module SnippetExtractor
  class ExtractSnippet
    include Mandate

    initialize_with :code, :language

    def call
      processed_lines
    rescue Errno::ENOENT
      code.lines[0...10].join
    end

    private
    def processed_lines
      if ignore_list[0].include? "!e"
        Extended::Extract.(code, ignore_list).join
      else
        Basic::Extract.(code, ignore_list).join
      end
    end

    memoize
    def ignore_list
      slug = language.to_s.gsub(/[^a-z0-9-]/, '')
      File.read(File.expand_path("../../languages/#{slug}.txt", __FILE__)).lines.map(&:rstrip)
    end
  end
end
