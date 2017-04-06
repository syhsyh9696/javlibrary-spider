# encoding:utf-8

File.open("./all.txt", "w") do |io|
    'A'.upto('Z') do |alphabet|
        File.open("./#{alphabet}.txt", "r") do |io_read|
            while line = io_read.gets
                io << line
            end
        end
    end
end
