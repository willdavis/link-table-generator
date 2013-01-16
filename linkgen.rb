#!/usr/bin/ruby

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
File.open(@linkCSV, 'w') do |wfile|
	#Format the column headers
	wfile.puts("LINK_NAME#{@delimiter}LINK_URL#{@delimiter}LINK_CATEGORY#{@delimiter}CLICKTHROUGH_ATTRIBUTES#{@delimiter}CLICKTHROUGH_DELIMITER#{@delimiter}FILE_PATH")

	#Write each row to the CSV file
	@matches.each do |match|
		wfile.puts("#{@delimiter}#{match[0]}#{@delimiter}#{@delimiter}#{@delimiter}#{@delimiter}#{match[1]}")
	end
end

puts "All done!"
puts "link table generated at: #{@linkCSV}"
puts "Total URL's extracted: #{@matches.count}"