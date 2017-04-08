# encoding:utf-8

require 'rest-client'
require 'nokogiri'
require 'pp'

baseurl = "http://www.jav11b.com/cn/?v=javlijqf2e"

response = RestClient.get baseurl
doc = Nokogiri::HTML(response.body)
details, genres = Array.new, Array.new

doc.search('//div[@id="video_info"]/div[@class="item"]/table/tr/td[@class="text"]').map do |row|    
    details << row.children.text
end

video_id = details[0]
video_date = details[1]
video_director = details[2]
video_maker = details[3]
video_label = details[4]
video_cast = details[-1]
video_genres = String.new

pp details 
doc.search('//div[@id="video_genres"]/table/tr/td[@class="text"]/span[@class="genre"]/a').each do |row|
    video_genres << row.children.text << " "
end
pp video_genres


