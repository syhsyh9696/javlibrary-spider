# encoding:utf-8

require 'rest-client'
require 'nokogiri'
require 'pp'

baseurl = "http://jav11b.com/cn/?v=javlio354y"

response = RestClient.get baseurl
doc = Nokogiri::HTML(response.body)


title, details, genres = String.new, Array.new, Array.new

title =  doc.search('div[@id="video_title"]/h3/a').children.text

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

test = doc.search('//img[@id="video_jacket_img"]').each do |row|
    pp row['src']
end
