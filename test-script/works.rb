# encoding:utf-8

require 'rest-client'
require 'nokogiri'
require 'pp'

baseurl = "http://www.jav11b.com/cn/?v=javlijqf2e"

response = RestClient.get baseurl
doc = Nokogiri::HTML(response.body)
details = Array.new

doc.search('//div[@id="video_info"]/div[@class="item"]/table/tr/td[@class="text"]').map do |row|    
    details << row.children.text
end

p details.class
pp details

details_temp = doc.search('//div[@id="video_genres"]/table/tr/td[@class="text"]/span[@class="genre"]/a').each do |row|
    p row.children.text
end

