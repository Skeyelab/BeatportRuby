# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

puts 'Renaming files...'

folder_path = "/PATH/TO/YOUR/MUSIC"
Dir.glob("#{folder_path}*.aiff").sort.each do |f|
  filename = File.basename(f, File.extname(f))

  next if filename.split('_')[0].to_i.zero?

  puts "looking for #{filename.split('_', 2)[1]}"
  begin
    url = "https://www.beatport.com/track/#{filename.split('_', 2)[1].downcase.gsub('_', '-')}/#{filename.split('_')[0]}"

    response = HTTParty.get(url);
  rescue => exception
    binding.pry   
  end  

  parsed_data = Nokogiri::HTML.parse(response.body)

  next unless parsed_data.title != 'Oh No! 404 — Not Found'

  new_filename = "#{parsed_data.title.split('by ')[1].split(' on ')[0]} - #{parsed_data.title.split('by ')[0].strip.gsub("/","_")}"
  puts "Renaming to #{new_filename}"
  File.rename(f, folder_path + new_filename + File.extname(f))
end

puts 'Renaming complete.'
