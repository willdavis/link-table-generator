#!/usr/bin/ruby

require 'csv'

@delimiter = ","
@regex_html = /<a href="(\S*)"/
@regex_text = /(https?\S*)/
@matches = []
@linkCSV = "#{File.dirname(__FILE__)}/#{Time.now.to_s.gsub(/ |:/,'')}_linktable.csv"

puts "Scanning HTML files for http(s) substrings..."
ARGV.each do |arg|
	File.open(arg, 'r') do |rfile|
		case File.extname(arg)
		when ".html"
			fcontent = rfile.read
			fcontent.scan(@regex_html) do |match|
				@matches.push([match.first, rfile.path])
			end
		when ".txt"
			fcontent = rfile.read
			fcontent.scan(@regex_text) do |match|
				@matches.push([match.first, rfile.path])
			end
		else
			puts "File extension not recognized"
		end
	end
end

@matches.each do |match|
	puts "Found: #{match[0]} in: #{match[1]}"
end

puts "Creating link table..."
CSV.open(@linkCSV, 'w', :headers => true) do |csv|
	csv << %w[LINK_NAME LINK_URL LINK_CATEGORY CLICKTHROUGH FILE_PATH]
	
	@matches.each do |match|
		csv << ["", "#{match[0]}", "", "", "#{match[1]}"]
	end
end

puts "All done!"
puts "link table generated at: #{@linkCSV}"
puts "Total URL's extracted: #{@matches.count}"