#!/usr/bin/ruby

@regex_html = /<a href="(\S*)"/
@regex_text = /(https?\S*)/
@matches = []
@linkCSV = "#{File.dirname(__FILE__)}/#{Time.now.to_s.gsub(/ |:/,'')}_linkTable.csv"

puts "Scanning HTML files for http(s) substrings..."
ARGV.each do |arg|
	File.open(arg, 'r') do |rfile|
		case File.extname(arg)
		when ".html"
			while line = rfile.gets
				matchdata = line.match @regex_html
				@matches.push([matchdata[1],File.basename(rfile)]) if matchdata
			end
		when ".txt"
			while line = rfile.gets
				matchdata = line.match @regex_text
				@matches.push([matchdata[1],File.basename(rfile)]) if matchdata
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
	wfile.puts("FILE_NAME,LINK_NAME,LINK_URL,LINK_CATEGORY")

	#Write each row to the CSV file
	@matches.each do |match|
		wfile.puts("#{match[1]},,#{match[0]},")
	end
end

puts "All done!"
puts "link table generated at: #{@linkCSV}"
puts "Total URL's extracted: #{@matches.count}"