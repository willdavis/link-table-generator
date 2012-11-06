#!/usr/bin/ruby

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

#DEBUG OUTPUT
@csv_buffer.each do |item|
	puts item
end

@creatives.each do |fname, content|
	puts "#{fname} content is:\n#{content}"
end

