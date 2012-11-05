#!/usr/bin/ruby

@regex = /<a href="(\S*)"/
@matches = []
@linkCSV = "#{File.dirname(__FILE__)}/#{Time.now.to_s.gsub(/ |:/,'')}_linkTable.csv"

puts "Scanning HTML files for <a href> tags..."
ARGV.each do |arg|
	File.open(arg, 'r') do |rfile|
		while line = rfile.gets
			match = line.match @regex
			@matches.push([match[1],arg]) if match
		end
	end
end

@matches.each do |match|
	puts "Extracting: #{match[0]} from: #{match[1]}"
end

File.open(@linkCSV, 'w') do |wfile|
	#Format the column headers
	wfile.puts("FILE_NAME,LINK_NAME,LINK_URL,LINK_CATEGORY")

	#Write each row to the CSV file
	@matches.each do |match|
		wfile.puts("#{match[1]},,#{match[0]},")
	end
end

puts "Total URL's extracted: #{@matches.count}"