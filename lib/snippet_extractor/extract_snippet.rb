module SnippetExtractor
  class ExtractSnippet
    include Mandate

    initialize_with :code, :language

    def call
      lines.map { |line| cut_line(line) }.join
    end

    private
    def lines
      processed_lines
    rescue Errno::ENOENT
      code.lines[0...MAX_LINES]
    end

    def processed_lines
      if ignore_list[0].include? "!e"
        Extended::Extract.(code, ignore_list)
      else
        Basic::Extract.(code, ignore_list)
      end
    end

    # Cuts the line to MAX_LINE_LENGTH characters (not bytes) and keeps its newline.
    # The newline does not count towards the length. No marker is added.
    def cut_line(line)
      text = line.chomp
      return line if text.length <= MAX_LINE_LENGTH

      text[0, MAX_LINE_LENGTH] + line[text.length..]
    end

    memoize
    def ignore_list
      slug = language.to_s.gsub(/[^a-z0-9-]/, '')
      File.read(File.expand_path("../../languages/#{slug}.txt", __FILE__), encoding: 'UTF-8').lines.map(&:rstrip)
    end
  end
end
