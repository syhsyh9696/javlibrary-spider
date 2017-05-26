# encoding:utf-8

io_write = File.open("./resources/all_works.txt", "w")

'0000'.upto('0047').each do |num|
    File.open("./resources/works_info/#{num}.txt") do |io|
        while line = io.gets
            io_write << line
        end
    end
end
io_write.close
