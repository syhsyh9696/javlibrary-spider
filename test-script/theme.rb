# encoding:utf-8

require 'rest-client'
require 'nokogiri'
require 'pp'

response = RestClient.get "http://www.jav11b.com/cn/genres.php"

doc = Nokogiri::HTML(response.body)
genres = Array.new
doc.search('//div[@class="genreitem"]/a').each do |row|
    genres << row.children.text
end

io = File.open("../resources/all_genres.txt", "w")
genres.each { |item| io << item << "\n" }
io.close

