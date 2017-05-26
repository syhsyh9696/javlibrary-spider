# encoding:utf-8

require 'mysql2'
require 'mechanize'
require 'mechanize'
require 'pp'


module Javlibrary
    def Javlibrary.downloader(identifer)
        baseurl = "http://www.jav11b.com/cn/?v=#{identifer}"
        response = Mechanize.new
        response.user_agent = Mechanize::AGENT_ALIASES.values[rand(21)]
        begin
            response.get baseurl
        rescue
            retry
        end

        doc = Nokogiri::HTML(response.page.body)

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
        
        # return data format: title$id$date$director$maker$label$cast$genres$img_url
        "#{video_title}$#{details[0]}$#{details[1]}$#{details[2]}$#{details[3]}$#{details[4]}$#{details[-1]}$#{video_genres}$#{video_jacket_img}"  
        #result = Hash.new
        #result["title"] = video_title; result["id"] = details[0]; result["date"] = details[1]
        #result["director"] = details[2]; result["maker"] = details[3]; result["label"] = details[4]
        #result["cast"] = details[-1]; result["genres"] = video_genres; result["img_url"] = video_jacket_img
    end

    def video_info_insert(client, identifer, actor_hash, genres_hash)
        result = downloader(identifer)
        title, id, date, director, maker, label, cast_tmp, genres_tmp, img_url = line.chomp.split('$')
        cast = cast_tmp.split.reject(&:empty?)
        genres = genres_tmp.split.reject(&:empty?)
        begin
            client.query("INSERT INTO video (video_id,video_name,license,url,director,label,date,maker)
            VALUES (#{index},'#{title}','#{id}','#{img_url}','#{director}','#{label}','#{date}','#{maker}')")
        rescue
            next
        end
        cast.each do |a|
            a_tmp = actor_hash[a]
            next if a_tmp == nil
            client[num.to_i].query("INSERT INTO v2a (v2a_fk_video,v2a_fk_actor) VALUES(#{index}, #{a_tmp.to_i})")
        end
        
        genres.each do |g|
            g_tmp = category_hash[g]
            next if g_tmp == nil
            client[num.to_i].query("INSERT INTO v2c (v2c_fk_video,v2c_fk_category) VALUES(#{index}, #{g_tmp.to_i})")
        end

        
    end

    def test
        pp downloader('javlia322m')
    end
    
    module_function :test
end

Javlibrary::test
