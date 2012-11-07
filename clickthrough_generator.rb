#!/usr/bin/ruby

class LinkTableRow
	attr_accessor :file_name, :link_name, :link_url, :link_category, :clickthrough_attributes
	
	def initialize(string)
		line = string.split(",")
		@link_name = line[0]
		@link_url = line[1]
		@link_category = line[2]
		@clickthrough_attributes = line[3]
		@file_name = line[4]
	end
	
	def show
		puts "#{file_name}:#{link_name}:#{link_url}:#{link_category}:#{clickthrough_attributes}"
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

@csv_buffer.each do |line|
	item = LinkTableRow.new(line)
	item.show
end