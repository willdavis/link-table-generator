#!/usr/bin/ruby

#The first command line ARGV is the absoulte file path for the target HTML file.
puts "Parsing: #{ARGV[0]}"

@regex = /<a href="(\S*)"/
@matches = []
@linkCSV = "#{File.dirname(__FILE__)}/linkTable.csv"
puts @linkCSV

File.open(ARGV[0], 'r') do |rfile|
	while line = rfile.gets
		match = line.match @regex
		@matches.push(match[1]) if match
	end
end

@matches.each do |match|
	puts "Found: #{match}"
end

#File.open(@linkCSV, 'w') do |wfile|
#	@matches.each do |match|
#		wfile.puts(match)
#	end
#end