require "test_helper"

module SnippetExtractor
  module Languages
    class UnisonTest < Minitest::Test
      def test_full_example
        code = <<~CODE
          use base.Text
          use base.List map

          {-
          Multiline comment
          -}

          -- Inline comment

          {{
            This is documentation for a function
            It is very important content

            ```1+2```
          }}
          testRunner.main : '{IO,Exception}()
          testRunner.main _ =
            solutionPrefix = io.getEnv "solution_dir"
            testAnnotationFilePath = FilePath (solutionPrefix Text.++ "/.meta/testAnnotation.json")
            annotations = !(parseAnnotationFile testAnnotationFilePath)
            json = toV2TestFile tests annotations |> toJson
            testRunner.checkAnnotationFile annotations tests
            jsonString = json |> compact
            envFilePath = io.getEnv "results_file"
            filePath = FilePath ( envFilePath )
        CODE

        expected = <<~CODE
          testRunner.main : '{IO,Exception}()
          testRunner.main _ =
            solutionPrefix = io.getEnv "solution_dir"
            testAnnotationFilePath = FilePath (solutionPrefix Text.++ "/.meta/testAnnotation.json")
            annotations = !(parseAnnotationFile testAnnotationFilePath)
            json = toV2TestFile tests annotations |> toJson
            testRunner.checkAnnotationFile annotations tests
            jsonString = json |> compact
            envFilePath = io.getEnv "results_file"
            filePath = FilePath ( envFilePath )
        CODE

        assert_equal expected, ExtractSnippet.(code, :unison)
      end

      def test_extended_sample
        code = <<~CODE
          use base.Text
          use base.List map

          {-
          Multiline comment
          -}

          -- Inline comment

          {{
            This is documentation for a function
            It is very important content

            ```1+2```
          }}
          usefulTestRunner.main : '{IO,Exception}()
          usefulTestRunner.main _ =
            use base.Text join ++
            solutionPrefix = io.getEnv "solution_dir"
            {{I am a doc block in the middle}}
            -- I am a comment hanging out here
            {-
              multi line comment in block
            -}
            testAnnotationFilePath = FilePath (solutionPrefix Text.++ "/.meta/testAnnotation.json")
            annotations = !(parseAnnotationFile testAnnotationFilePath)
            testRunner.checkAnnotationFile annotations tests
            json = toV2TestFile tests annotations |> toJson
            jsonString = json |> compact
            envFilePath = io.getEnv "results_file"
            filePath = FilePath ( envFilePath )
        CODE

        expected = <<~CODE
          usefulTestRunner.main : '{IO,Exception}()
          usefulTestRunner.main _ =
            solutionPrefix = io.getEnv "solution_dir"
            testAnnotationFilePath = FilePath (solutionPrefix Text.++ "/.meta/testAnnotation.json")
            annotations = !(parseAnnotationFile testAnnotationFilePath)
            testRunner.checkAnnotationFile annotations tests
            json = toV2TestFile tests annotations |> toJson
            jsonString = json |> compact
            envFilePath = io.getEnv "results_file"
            filePath = FilePath ( envFilePath )
        CODE

        assert_equal expected, ExtractSnippet.(code, :unison)
      end
    end
  end
end
