# encoding:utf-8

require 'mysql2'
require 'pp'

Sqlserver = "127.0.0.1"
client = Mysql2::Client.new(:host => "#{Sqlserver}", :username => "root", :password => "default", :database => "javlibrary")

actor_hash = Hash.new
client.query("SELECT * FROM actor").each do |item|
    actor_hash["#{item['actor_name']}"] = item['actor_id']
end

category_hash = Hash.new
client.query("SELECT * FROM category").each do |item|
    category_hash["#{item['category_name']}"] = item['category_id']
end

File.open("./all_works.txt", "r") do |io|
    i = 1
    while line = io.gets
        # return data format: title$id$date$director$maker$lable$cast$genres$img_url
        title, id, date, director, maker, label, cast_tmp, genres_tmp, img_url = line.chomp.split('$')
        cast = cast_tmp.split.reject(&:empty?)
        genres = genres_tmp.split.reject(&:empty?)

        begin
            client.query("INSERT INTO video (video_id,video_name,license,url,director,label,date,maker) VALUES (#{i},'#{title}','#{id}','#{img_url}','#{director}','#{label}','#{date}','#{maker}')")
        rescue Exception => e
            next
        end

        cast.each do |a|
            a_tmp = actor_hash[a]
            next if a_tmp == nil
            sql = "INSERT INTO v2a (v2a_fk_video,v2a_fk_actor) VALUES(#{i}, #{a_tmp.to_i})"
            begin
                client.query("INSERT INTO v2a (v2a_fk_video,v2a_fk_actor) VALUES(#{i}, #{a_tmp.to_i})")
            rescue Exception => e
                p sql
                p e
            end
        end

        genres.each do |g|
            g_tmp = category_hash[g]
            next if g_tmp == nil
            sql = "INSERT INTO v2c (v2c_fk_video,v2c_fk_category) VALUES(#{i}, #{g_tmp.to_i})"
            begin
                client.query("INSERT INTO v2c (v2c_fk_video,v2c_fk_category) VALUES(#{i}, #{g_tmp.to_i})")
            rescue Exception => e
                p sql
                p e
            end
        end

        i += 1
    end
end
client.close
