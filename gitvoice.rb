#!/usr/bin/env ruby

require 'date'
require 'yaml'

email = `git config --get user.email`.strip
puts "git log --author=\"#{email}\" --format=\"format:%aI|%s\""
log = `git log --author="#{email}" --format="format:%aI|%s"`
commits = {}

log.split("\n").map do |line|
  date, subject = line.split('|')
  [Date.parse(date), subject]
end.reverse.select do |date, _|
  date >= Date.parse(ARGV[0])
end.each do |date, subject|
  commits[date] ||= []
  # relying on ordered hash
  commits[date] << subject
end

work = commits.map do |date, lines|
  description = lines.count > 1 ? lines : lines[0] 
  { 'date' => date, 'description' => description, 'hours' => 0 }
end

puts ({ 'work' => work }).to_yaml(indentation: 2)
