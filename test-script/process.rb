# encoding:utf-8

require 'nokogiri'
require 'rest-client'

firsturl = "http://www.javlibrary.com/cn/vl_star.php?s=area" 
baseurl = "http://www.javlibrary.com/cn/vl_star.php?&mode=&s=area&page="

response = RestClient.get firsturl
doc = Nokogiri(response.body)

last_page = nil
page = doc.search('//div[@class="page_selector"]/a[@class="page last"]').each do |row|
    last_page = row['href'].split("=")[-1].to_i
end
#last_page = 1 if last_page == nil
p last_page

text = String.new
io_proc = File.open("process.txt", "w")
1.upto(last_page) do |page|
    tempurl = baseurl + page.to_s
    response = RestClient.get tempurl
    Nokogiri::HTML(response.body).search('//div[@class="video"]/a').each do |row|
        text << row['title'] << "\n"
    end
end
io_proc << text << "#{page}\n"
io_proc.close
