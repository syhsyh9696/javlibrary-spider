# encoding:utf-8

require 'rest-client'
require 'nokogiri'

def download_thread(filename)
    File.open("../resources/#{filename}.txt", "r") do |io|
        while line = io.gets
            code, name = line.chomp!.split
            firsturl = "http://www.jav11b.com/ja/vl_star.php?s=#{code}"
            baseurl = "http://www.jav11b.com/ja/vl_star.php?&mode=&s=#{code}&page="

            begin
                response = RestClient.get firsturl
            rescue
                retry
            end

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
                    text << row['href'].split("=")[-1] << " " << row['title'] << "\n"
                end
            end

            io_proc = File.open("./thread_test/#{name}.txt", "w")
            io_proc << text
            io_proc.close
        end
    end
end

thread = Array.new
'A'.upto('Z') do |alphabet|
    temp = Thread.new{ download_thread(alphabet) }
    thread << temp
end

thread.each do |te|
    te.join
end
