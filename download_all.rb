# encoding:utf-8

require 'rest-client'
require 'nokogiri'

File.open("code_name.txt", "r") do |io|
    while line = io.gets
        code, name = line.chomp!.split
        firsturl = "http://www.javlibrary.com/cn/vl_star.php?s=#{code}"
        baseurl = "http://www.javlibrary.com/cn/vl_star.php?&mode=&s=#{code}&page="

        response = RestClient.get firsturl
        doc = Nokogiri::HTML(response.body)

        last_page = 1
        doc.search('//div[@class="page_selector"]/a[@class="page last"]').each do |row|
            last_page = row['href'].split("=")[-1].to_i
        end

        text = String.new

        1.upto(last_page) do |page|
            tempurl = baseurl + page.to_s
            response = RestClient.get tempurl
            Nokogiri::HTML(response.body).search('//div[@class="video"]/a').each do |row|
                text << row['title'] << "\n"
            end
        end
        
        io_proc = File.open("./works_all/#{name}.txt", "w")
        io_proc << text
        io_proc.close
    end
end
