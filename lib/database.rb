# encoding: utf-8

require 'mysql2'

module Javlibrary
    def client
        client = Mysql2::Client.new(:host => "127.0.0.1",
                                    :username => "root",
                                    :password => "XuHefeng",
                                    :database => "javlibrary_new")
    end

    module_function :client
end


