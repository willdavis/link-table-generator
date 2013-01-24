#!/usr/bin/ruby

require 'csv'

@creatives = Hash.new
@csv_path = ""

# Open files passed via command line and read their contents into a buffer.
ARGV.each do |arg|
	File.open(arg, 'r') do |rfile|
		puts "Loading #{rfile.path}..."
		
		case File.extname(arg)
		when ".html"
			@creatives["#{rfile.path}"] = rfile.read
		when ".txt"
			@creatives["#{rfile.path}"] = rfile.read
		when ".csv"
			@csv_path = rfile.path
		else
			puts "\nFile Extension not recognized!\nUnable to load #{rfile.path}\n\n"
		end
	end
end

puts "\nAll files loaded.\n"
puts "Building clickthroughs..."

CSV.foreach(@csv_path, :headers => true) do |row|
	puts row[1]
end

# loop through the CSV buffer and replace URLs with clickthroughs
#@csv_buffer.each do |line|
#	row = LinkTableRow.new(line)
#
#	if @creatives.keys.include?(row.file_path)
#		@creatives[row.file_path].sub!(row.link_url,row.build_clickthrough)
#	end
#end

# All URLs have been replaced.  Save each buffer to their corresponding files
#@creatives.each_key do |key|
#	File.open(key, 'w') do |wfile|
#		wfile.write(@creatives[key])
#	end
#end

#def build_clickthrough
#	@clickthrough_attributes.gsub!(@clickthrough_delimiter, ',')
#	"$clickthrough(#{@link_name}#{@clickthrough_attributes})$"
#end