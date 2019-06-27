for j in 1..@width do
    print "    #{j}\t"
end
puts ''
for i in 1..@length do
    print "_" * (81 * (@width.to_f/10))
    puts ""
    print "#{i}"
    for j in 1..@width do
        if @map[[i,j]] == [:empty]
            print "|\t"
        else
            print "|  #{@map[[i,j]]}\t"
        end
    end
    print "\n"
end