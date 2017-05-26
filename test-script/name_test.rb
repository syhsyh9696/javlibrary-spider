# encoding:utf-8

require 'rest-client'
require 'nokogiri'
require 'pp'

baseurl = "http://www.javlibrary.com/cn/star_list.php?prefix=A&page=2"
response = RestClient.get baseurl
text = String.new

doc = Nokogiri::HTML(response.body)
doc.search('//div[@class="starbox"]/div[@class="searchitem"]/a').each do |row|
    text << row['href'].split('=')[-1] << "\n"

end
pp text

