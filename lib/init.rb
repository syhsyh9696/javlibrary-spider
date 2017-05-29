# encoding:utf-8

require 'mechanize'
require 'nokogiri'
require 'mysql2'

require_relative 'database'

module Javlibrary
    def Javlibrary.genres
        response = Mechanize.new; genres = Array.new
        begin
            response.get "http://www.jav11b.com/cn/genres.php"
        rescue
            retry
        end

        Nokogiri::HTML(response.page.body).search('//div[@class="genreitem"]/a').each do |row|
            genres << row.children.text
        end
        genres.uniq
    end

    def genres_insert
        client = Javlibrary.client
        genres = genres()
        genres.each do |e|
            begin
                client.query("INSERT INTO category (category_name) VALUES ('#{e}')")
            rescue
                next
            end
        end

        client.close
    end

    module_function :genres_insert
end

Javlibrary::genres_insert
