#!/usr/bin/ruby

#The first command line ARGV is the absoulte file path for the target HTML file.
puts "Parsing: #{ARGV[0]}"

@regex = /<a href="(\S*)"/
@matches = []

File.open(ARGV[0], 'r') do |f|
	while line = f.gets
		match = line.match @regex
		@matches.push(match[1]) if match
	end
end

@matches.each do |match|
	puts "Found: #{match}"
end