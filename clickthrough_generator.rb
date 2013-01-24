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
puts "Using #{@csv_path}"
puts "Building clickthroughs..."

#	0			1			2				3			4					5
# [LINK_NAME, LINK_URL, LINK_CATEGORY, CLICKTHROUGH, CLICKTHROUGH_PARAMS, FILE_PATH]

# loop through the CSV file and generate clickthroughs based off the LINK_NAME and CLICKTHROUGH_PARAMS
# Skip if the CLICKTHROUGH field is NOT empty
CSV.foreach(@csv_path, :headers => true) do |row|
	clickthrough = "$clickthrough(#{row["LINK_NAME"]}"
	unless row["CLICKTHROUGH_PARAMS"].nil?
		clickthrough.concat(",#{row["CLICKTHROUGH_PARAMS"]}")
	end
	clickthrough.concat(")$")
	puts clickthrough
end

# Replace LINK_URL with CLICKTHROUGH in each creative file
#if @creatives.keys.include?(row[5])
#	@creatives[row[5]].sub!(row[1],row[3])
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