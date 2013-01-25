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

#	0			1			2				3			4					5				6
# [LINK_NAME LINK_URL LINK_CATEGORY CLICKTHROUGH CLICKTHROUGH_PARAMS EXTRACTED_LINK_URL FILE_PATH]

# Replace LINK_URL with CLICKTHROUGH in each creative file
CSV.foreach(@csv_path, :headers => true) do |row|
	if @creatives.keys.include?(row["FILE_PATH"])
		@creatives[row["FILE_PATH"]].sub!(row["EXTRACTED_LINK_URL"],row["CLICKTHROUGH"])
	end
end

# All URLs have been replaced.  Save each buffer to their corresponding files
@creatives.each_key do |key|
	File.open(key, 'w') do |wfile|
		wfile.write(@creatives[key])
	end
end