# encoding:utf-8

name_io = File.open('./resources/name_all.txt', 'w')
name_array = Array.new
File.open('./resources/code_name.txt', 'r') do |io|
    while line = io.gets
        code, name = line.chomp.split
        name_io << name << "\n"
        name_array << name
    end
end
name_io.close

p name_array.size
p name_array.uniq.size
