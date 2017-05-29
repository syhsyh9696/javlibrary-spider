# encoding:utf-8

require 'rest-client'
require 'nokogiri'
require 'mysql2'
require 'redis'
require 'pp'

require_relative 'database'


module Javlibrary
    def Javlibrary.download_video_label(actor_id)
        firsturl = "http://www.jav11b.com/ja/vl_star.php?s=#{actor_id}"
        baseurl = "http://www.jav11b.com/ja/vl_star.php?&mode=&s=#{actor_id}&page="

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

        result = []
        1.upto(last_page) do |page|
            tempurl = baseurl + page.to_s
            response = RestClient.get tempurl
            Nokogiri::HTML(response.body).search('//div[@class="video"]/a').each do |row|
                # Data:
                # Video_label: row['href'].split("=")[-1]
                # Video_title: row['title']
                # client.query("INSERT INTO label (lable) VALUES ('#{row['href'].split("=")[-1]}')")
                result << row['href'].split("=")[-1]
            end
        end

        client = Javlibrary.client
        result.each do |e|
            begin
                client.query("INSERT INTO label (video_label, video_download) VALUES ('#{e}', '0')")
            rescue
                next
            end
        end
        client.close
    end

    def Javlibrary.select_actor(type)
        client = Javlibrary.client
        result = client.query("SELECT actor_label FROM actor WHERE type='#{type}'")
        client.close

        result.each do |e|
            download_video_label(e["actor_label"])
        end
    end

    def download_all_video_label
        thread_pool =[]
        'A'.upto('Z').each do |alphabet|
            thread_temp = Thread.new{
                select_actor(alphabet)
            }
            thread_pool << thread_temp
        end
        thread_pool.map(&:join)
    end

    def download_all_video_info

    end

    module_function :download_all_video_label
end

Javlibrary::download_all_video_label
