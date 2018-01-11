#!/usr/bin/env ruby
#
# extractor.rb
#   USAGE: ./extractor.rb FILENAME
#
# Given a PDF file, extracts all the plain text data possible.
#
# Exit Codes:
#   1 - No filename argument given
#   2 - Given PDF didn't have any extractable text
#

if ARGV.count < 1
  puts "USAGE:"
  puts "./extractor.rb FILENAME"
  exit 1
end

require 'pdf-reader'
require 'pry'
require 'pp'

#
# Hold the pages as an array here so we can assess if ANY of them
# have text at all. If none do, print an error message and exit.
#

pdf = PDF::Reader.new(ARGV[0])
@pages = pdf.pages
unless @pages.any? { |p| p.text.length > 0 }
  puts "No text in the entire PDF."
  exit 2
end

@text = ''
pdf.pages.each { |p| @text << p.text }

#
# Ideally there should be ONE entry on each line with ONE price
# next to it. See if you can parse it that way...
#
@food = []
@text.each_line do |x|
  tmp = x.split(/(\d.*\.*\d.*)/)
  yummy = Hash.new
  yummy[:name]  = tmp[0].gsub(/\s/, '')
  yummy[:price] = tmp[1].to_f
  @food << yummy
end

#
# Put results on the screen
#
pp @food
