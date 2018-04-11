require_relative 'lib/alfred-3_workflow/alfred-3_workflow'

class Search
  attr_reader :workflow, :matches

  def initialize
    @workflow = Alfred3::Workflow.new
    @matches  = find_matches
  end

  def call
    return matches.each { |document_name| document_json(document_name) } if matches.any?
    no_match_json
  ensure
    print workflow.output
  end

  private

  def find_matches
    dir_path = "#{ENV['HOME']}/Library/Containers/pro.writer.mac/Data/Documents/"
    Dir["#{dir_path}*.txt"]
  end

  def document_json(file_path)
    base_name = File.basename(file_path)

    workflow.result
            .uid(base_name)
            .title(base_name)
            .arg(file_path)
            .text('copy', file_path)
            .autocomplete(base_name)
  end

  def no_match_json
    workflow.result
            .title('No matches found!')
            .subtitle('Try a different search term')
            .valid(false)
  end
end

Search.new.call
