module StreamsHelper
  def truncate_to_words(string, n)
    shortened = truncate(string, :length => n, :omission => '')
    last_space = shortened.rindex(" ")
    "#{last_space ? shortened : shortened.slice(0..last_space - 1)}..."
  end
end
