# encoding:utf-8

require 'rest-client'
require 'nokogiri'

def author_page_num(nokogiri_doc)
    last_page = 1
    nokogiri_doc.search('//div[@class="page_selector"]/a[@class="page last"]').each do |row|
        last_page = row['href'].split("=")[-1].to_i
    end
    last_page
end

firsturl = "http://www.javlibrary.com/cn/star_list.php?prefix="

'A'.upto('Z') do |alphabet|
    tempurl = firsturl + alphabet
    response = RestClient.get tempurl

    doc = Nokogiri::HTML(response.body)
    last_page = author_page_num(doc)

    text = String.new
    1.upto(last_page) do |page_num|
        temp_page_url = tempurl + "&page=#{page_num.to_s}"
        response_page = RestClient.get temp_page_url
        doc_page = Nokogiri::HTML(response_page.body)
        doc_page.search('//div[@class="starbox"]/div[@class="searchitem"]/a').each do |row|
            p row
            text << row['href'].split("=")[-1] << "\n"
        end
    end

    io = File.open("#{alphabet}.txt", "w")
    io << text
    text = ""
    io.close
end
