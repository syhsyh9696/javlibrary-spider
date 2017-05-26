# encoding:utf-8

require "rest-client"
require "nokogiri"

module Javlibrary
    def Javlibrary.download_all_works(identifer)
        baseurl = "http://www.jav11b.com/cn/?v=#{identifer}"

        begin
            response = RestClient.get baseurl
        rescue
            retry
        end

        doc = Nokogiri::HTML(response.body)
        video_title, details, video_genres, video_jacket_img = String.new, Array.new, String.new, String.new

        video_title = doc.search('div[@id="video_title"]/h3/a').children.text
        doc.search('//div[@id="video_info"]/div[@class="item"]/table/tr/td[@class="text"]').map do |row|
            details << row.children.text
        end

        doc.search('//div[@id="video_genres"]/table/tr/td[@class="text"]/span[@class="genre"]/a').each do |row|
            video_genres << row.children.text << " "
        end

        doc.search('//img[@id="video_jacket_img"]').each do |row|
            video_jacket_img = row['src']
        end


        # return data format: title$id$date$director$maker$lable$cast$genres$img_url
        "#{video_title}$#{details[0]}$#{details[1]}$#{details[2]}$#{details[3]}$#{details[4]}$#{details[-1]}$#{video_genres}$#{video_jacket_img}"
    end

end




thread = Array.new
"0000".upto("0047") do |num|
    temp = Thread.new {
        io_write = File.open("./works_info/#{num}.txt", "w")
        File.open("./identifer/ident_#{num}", "r") do |io|
            while line = io.gets
                result = download_all_works(line.chomp)
                io_write << result << "\n"
            end
        end
        io_write.close
    }
    thread << temp
end

thread.each do |te|
    te.join
end
