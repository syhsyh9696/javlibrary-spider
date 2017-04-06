# encoding:utf-8

require 'rest-client'
require 'nokogiri'

response = RestClient.get 'http://www.javlibrary.com/cn/vl_star.php?s=azjsc'
io = File.open("t.html", "w")
io << response.body
io.close

text = String.new
doc = Nokogiri::HTML(response.body)
p doc.search('//title').map(&:text)[1].split(" ")[0]
details = doc.search('//div[@class="video"]/a').each do |row|
    text << row['title'] << "\n"
end

io_proc = File.open("process.txt", "w")
io_proc << text
io.close

last_page = nil
page = doc.search('//div[@class="page_selector"]/a[@class="page last"]').each do |row|
    last_page = row['href'].split("=")[-1].to_i
end

p last_page == nil
p last_page
