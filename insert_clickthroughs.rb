#!/usr/bin/ruby

require 'csv'

@creatives = Hash.new
@match_count = 0
@csv_path = ""

# Open files passed via command line and read their contents into a buffer.
ARGV.each do |arg|
	File.open(arg, 'r') do |rfile|
		puts "Loading file: #{rfile.path}..."
		
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

puts "\nAll files loaded."
puts "Inserting CLICKTHROUGH fields into HTML/TXT files..."

#	0			1			2				3			4					5				6
# [LINK_NAME LINK_URL LINK_CATEGORY CLICKTHROUGH CLICKTHROUGH_PARAMS EXTRACTED_LINK_URL FILE_PATH]

# Replace LINK_URL with CLICKTHROUGH in each creative file
CSV.foreach(@csv_path, :headers => true) do |row|
	if @creatives.keys.include?(row["FILE_PATH"])
		#notify that a match was detected
		puts "\nMatched \"#{row["EXTRACTED_LINK_URL"]}\" in: #{row["FILE_PATH"]}"
		@match_count += 1
		
		#Check if the EXTRACTED_LINK_URL is present.
		unless row["EXTRACTED_LINK_URL"].nil?
			#Regex search the document for EXTRACTED_LINK_URL and substitute the FIRST match with CLICKTHROUGH field.
			@creatives[row["FILE_PATH"]].sub!(row["EXTRACTED_LINK_URL"],row["CLICKTHROUGH"])
		else
			#Handles special case where the <a href> tag has empty string as URL.
			#using sub!() on the string "" will insert content at the beginning of the document.
			
			#note:  This should only be present in HTML versions, since Text versions do not include any HTML tags.
			
			@creatives[row["FILE_PATH"]].sub!("<a href=\"\"","<a href=\"#{row["CLICKTHROUGH"]}\"")
		end
	end
end

# All URLs have been replaced.
# Save each buffer back to their corresponding files
@creatives.each_key do |key|
	File.open(key, 'w') do |wfile|
		wfile.write(@creatives[key])
	end
end

#Notify that the script has finished running.
puts "\nClickthrough insertion complete.\nNumber of URLs updated: #{@match_count}"