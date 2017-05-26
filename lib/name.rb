# encoding:utf-8

require 'rest-client'
require 'nokogiri'
require 'mysql2'

module Javlibrary
    def Javlibrary.author_page_num(nokogiri_doc)
        last_page = 1
        nokogiri_doc.search('//div[@class="page_selector"]/a[@class="page last"]').each do |row|
            last_page = row['href'].split("=")[-1].to_i
        end
        last_page
    end

    def get_all_actor
        firsturl = "http://www.jav11b.com/cn/star_list.php?prefix="

        client = Javlibrary.client
        'A'.upto('Z') do |alphabet|
            tempurl = firsturl + alphabet
            response = RestClient.get tempurl

            doc = Nokogiri::HTML(response.body)
            last_page = author_page_num(doc)

            1.upto(last_page) do |page_num|
                temp_page_url = tempurl + "&page=#{page_num.to_s}"
                response_page = RestClient.get temp_page_url
                doc_page = Nokogiri::HTML(response_page.body)
                doc_page.search('//div[@class="starbox"]/div[@class="searchitem"]/a').each do |row|
                    # row.text Actor.name
                    # row['href'].split("=")[-1] Actor.label
                    name = row.text; label = row['href'].split("=")[-1]
                    begin
                        client.query("INSERT INTO actor (actor_name, actor_label, type)
                            VALUES ('#{name}', '#{label}', '#{alphabet}')")
                    rescue
                        next
                    end
                end
            end
        end
    end

    module_function :get_all_actor
end

Javlibrary::get_all_actor
