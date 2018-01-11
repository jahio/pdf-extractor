#!/usr/bin/env ruby
#
# extractor.rb
#   USAGE: ./extractor.rb FILENAME
#
# Given a PDF file, extracts all the plain text data possible.
# Flushes that plain text data into txt/SAMEFILE.txt.
#

if ARGV.count < 1
  puts "USAGE:"
  puts "./extractor.rb FILENAME"
  exit 1
end

require 'pdf-reader'
require 'pry'

#
# Hold the pages as an array here so we can assess if ANY of them
# have text at all. If none do, print an error message and exit.
#

pdf = PDF::Reader.new(ARGV[0])
@pages = pdf.pages
unless @pages.any? { |p| p.text.length > 0 }
  puts "No text in the entire PDF."
  exit 1
end

pdf.pages.each do |p|
  puts p.text
end
