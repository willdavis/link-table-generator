#!/usr/bin/ruby

class LinkTableRow
	attr_accessor :file_path, :link_name, :link_url, :link_category, :clickthrough_attributes, :clickthrough_delimiter
	
	def initialize(string)
		line = string.split(",")
		@link_name = line[0]
		@link_url = line[1]
		@link_category = line[2]
		@clickthrough_attributes = line[3]
		@clickthrough_delimiter = line[4]
		@file_path = line[5].chomp				#Chomp the trailing '\n' off the string
	end
	
	def show
		puts "#{link_name},#{link_url},#{link_category},#{clickthrough_attributes},#{@clickthrough_delimiter},#{file_path}"
	end
	
	def build_clickthrough
		@clickthrough_attributes.gsub!(@clickthrough_delimiter, ',')
		"$clickthrough(#{@link_name},#{@clickthrough_attributes})$"
	end
end

@creatives = Hash.new
@csv_buffer = []

# Open files passed via command line and read their contents into a buffer.
ARGV.each do |arg|
	File.open(arg, 'r') do |rfile|
		case File.extname(arg)
		when ".html"
			@creatives["#{rfile.path}"] = rfile.read
		when ".txt"
			@creatives["#{rfile.path}"] = rfile.read
		when ".csv"
			while line = rfile.gets
				@csv_buffer.push(line)
			end 
		else
			puts "File extension not recognized"
		end
	end
end

puts "All files loaded...\n"

# loop through the CSV buffer and replace URLs with clickthroughs
@csv_buffer.each do |line|
	row = LinkTableRow.new(line)
	
	row.show
	puts @creatives.keys.include?(row.file_path)
	puts row.build_clickthrough
end

# All URLs have been replaced.  Save each buffer to their corresponding files
