# encoding:utf-8

require 'mysql2'

Sqlserver = "127.0.0.1"
client = Array.new
0.upto(47) do |num|
    client_tmp = Mysql2::Client.new(:host => "#{Sqlserver}", :username => "root", :password => "XuHefeng", :database => "javlibrary")
    client[num] = client_tmp
end


actor_hash = Hash.new
client[0].query("SELECT * FROM actor").each do |item|
    actor_hash["#{item['actor_name']}"] = item['actor_id']
end

category_hash = Hash.new
client[0].query("SELECT * FROM category").each do |item|
    category_hash["#{item['category_name']}"] = item['category_id']
end

thread = Array.new

"0000".upto("0047") do |num|
    temp = Thread.new {
        File.open("./works_info/#{num}.txt", "r") do |io|
            while line = io.gets
                # index number
                index = io.lineno + num.to_i * 5000

                # return data format: title$id$date$director$maker$lable$cast$genres$img_url
                title, id, date, director, maker, label, cast_tmp, genres_tmp, img_url = line.chomp.split('$')
                cast = cast_tmp.split.reject(&:empty?)
                genres = genres_tmp.split.reject(&:empty?)
                begin
                    client[num.to_i].query("INSERT INTO video (video_id,video_name,license,url,director,label,date,maker) VALUES (#{index},'#{title}','#{id}','#{img_url}','#{director}','#{label}','#{date}','#{maker}')")
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
        end
    }
    temp.join
end
