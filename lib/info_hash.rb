# encoding:utf-8

require 'mysql2'

module Javlibrary
    def actor_hash
        client = Javlibrary.client
        actor_hash = Hash.new
        client.query("SELECT * FROM actor").each do |item|
            actor_hash["#{item['actor_name']}"] = item['actor_id']
        end

        actor_hash
    end

    def genre_hash
        client = Javlibrary.client
        category_hash = Hash.new
        client.query("SELECT * FROM category").each do |item|
            category_hash["#{item['category_name']}"] = item['category_id']
        end

        category_hash
    end

    module_function :actor_hash, :genre_hash
end
