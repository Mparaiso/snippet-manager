require 'test_helper'

class HighlightSnippetContentJobTest < ActiveJob::TestCase

  fixtures :all

  test 'when job is called, snippet.highlighted_content should get populated' do
    snippet = snippets(:hello_php)
    assert_nil snippet.highlighted_content
    HighlightSnippetContentJob.perform_now snippet
    snippet.reload
    assert_not_nil snippet.highlighted_content
  end

end
