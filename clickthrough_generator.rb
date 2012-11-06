#!/usr/bin/ruby

@creatives = Hash.new

ARGV.each do |arg|
	File.open(arg, 'r') do |rfile|
		case File.extname(arg)
		when ".html"
			@creatives["#{rfile.path}"] = rfile.read
		when ".txt"
			@creatives["#{rfile.path}"] = rfile.read
		when ".csv"
			
		else
			puts "File extension not recognized"
		end
	end
end

@creatives.each do |fname, content|
	puts "#{fname} has content: #{content}"
end

