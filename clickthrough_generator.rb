#!/usr/bin/ruby

require 'csv'

@csv_path = ""
@updated_rows = []

# Open files passed via command line and read their contents into a buffer.
ARGV.each do |arg|
	File.open(arg, 'r') do |rfile|
		puts "Loading file: #{rfile.path}..."
		
		case File.extname(arg)
		when ".csv"
			@csv_path = rfile.path
		else
			puts "\nFile Extension not recognized!\nUnable to load #{rfile.path}\n\n"
		end
	end
end

puts "Using #{@csv_path}"
puts "Building clickthroughs..."

#	0			1			2				3			4					5				6
# [LINK_NAME LINK_URL LINK_CATEGORY CLICKTHROUGH CLICKTHROUGH_PARAMS EXTRACTED_LINK_URL FILE_PATH]

# loop through the CSV file and generate clickthroughs based off the LINK_NAME and CLICKTHROUGH_PARAMS
CSV.foreach(@csv_path, :headers => true) do |row|

	#Check if the CLICKTHROUGH field is already present.
	#If NOT, build a $clickthrough()$ string based off of the LINK_NAME and CLICKTHROUGH_PARAMS fields.
	if row["CLICKTHROUGH"].nil?
		clickthrough = "$clickthrough(#{row["LINK_NAME"]}"
		unless row["CLICKTHROUGH_PARAMS"].nil?
			clickthrough.concat(",#{row["CLICKTHROUGH_PARAMS"]}")
		end
		clickthrough.concat(")$")
		
		row["CLICKTHROUGH"] = clickthrough
		
		#Notify that a new $clickthrough()$ String was generated
		puts "Generated: #{row["CLICKTHROUGH"]}"
	end
	
	#Check if the LINK_URL field is already present.
	#If NOT, set the field to the EXTRACTED_LINK_URL's value
	if row["LINK_URL"].nil?
		row["LINK_URL"] = row["EXTRACTED_LINK_URL"]
	end
	
	@updated_rows.push(row)
end

#Re-open the CSV file and write the updated rows to it
unless @updated_rows.empty?
	CSV.open(@csv_path, 'w', :headers => true) do |csv|
		csv << %w[LINK_NAME LINK_URL LINK_CATEGORY CLICKTHROUGH CLICKTHROUGH_PARAMS EXTRACTED_LINK_URL FILE_PATH]
		
		@updated_rows.each do |row|
			csv << row
		end
	end
		
	#Notify that the script has finished updating the CSV file.
	puts "\nCSV file has been successfully updated."
else
	#Notify that the script did not update anything.
	puts "\nNo changes to the CSV file were made."
end