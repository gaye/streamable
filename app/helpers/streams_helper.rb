module StreamsHelper
  def truncate_to_words(string, n)
    shortened = truncate(string, :length => n, :omission => '')
    last_space = shortened.rindex(" ")
    puts "last space: #{last_space}"
    last_space == nil ? "#{shortened}..." : "#{shortened.slice(0..last_space-1)}..."
  end
end