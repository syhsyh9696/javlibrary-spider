# encoding:utf-8

def traverse_dir(file_path, io)
    if File.directory? file_path
        Dir.foreach(file_path) do |file|
            if file !="." and file !=".."
                traverse_dir(file_path+"/"+file, io)
            end
        end
    else
        # puts "File:#{File.basename(file_path)}, Size:#{File.size(file_path)}"
        # p File.basename(file_path).class
        io << File.basename(file_path) << "\n" if File.size(file_path) != 0
    end
end

io = File.open("all_file_path.txt", "w")
tmp = traverse_dir("/home/server-admin/laosiji-script/works", io)
io.close

io_all = File.open("all_identifer.txt", "w")
File.open("all_file_path.txt", "r") do |io|
    while line = io.gets
        line.chomp!
        id = String.new
        File.open("./works/#{line}", "r") do |f|
            while line = f.gets
                identifer = line.chomp.split[0]
                id << identifer << "\n"
            end
            io_all << id 
        end
    end
end
io_all.close
