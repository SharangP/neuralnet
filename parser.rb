#########################
# Parser
#
# Sharang Phadke
# 11/30/2013
#########################

class Parser
    def neuralNet()
        fname = gets
        fname = fname.chomp
        File.open(fname, "r") do |file|
            while (line = file.gets)
                puts "#{line}"
            end
        end
    end
end
