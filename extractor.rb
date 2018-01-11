#!/usr/bin/env ruby
#
# extractor.rb
#   USAGE: ./extractor.rb FILENAME
#
# Given a PDF file, extracts all the plain text data possible.
#
# Exit Codes:
#   0 - Everything went great! :-)
#   1 - No filename argument given
#   2 - Given PDF didn't have any extractable text
#   3 - PDF has weird formatting that makes text extractable, but unintelligible
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
  puts "No text in the entire PDF. Human intervention required."
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
# Remove objects that are blank/nil in both name and price
#
@food.delete_if { |x| (x[:name] == "" || x[:name] == nil) && (x[:price] < 0.01) }

#
# See if there are any empty strings for food names, or zero-dollar items
#
if @food.any? { |x| (x[:name] == "") || x[:name].nil? || (x[:price] < 0.01) }
  pp @food
  puts "FORMAT ERROR: Cannot cleanly parse menu document. Human intervention required."
  exit 3
end

#
# Put results on the screen
#
pp @food
