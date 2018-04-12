require_relative 'lib/alfred-3_workflow/alfred-3_workflow'

class Search
  attr_reader :workflow, :matches

  def initialize
    @workflow = Alfred3::Workflow.new
    @matches  = find_matches
  end

  def call
    return matches.each { |match| document_json(match) } if matches.any?
    no_match_json
  ensure
    print workflow.output
  end

  private

  def find_matches
    local  = "#{ENV['HOME']}/Library/Containers/pro.writer.mac/Data/Documents/*.txt"
    icloud = "#{ENV['HOME']}/Library/Mobile Documents/*~pro~writer/Documents/*.txt"

    Dir.glob(local) + Dir.glob(icloud)
  end

  def document_json(file_path)
    base_name = File.basename(file_path, '.txt')

    workflow.result
            .uid(base_name)
            .title(base_name)
            .subtitle(file_path)
            .quicklookurl(file_path)
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
