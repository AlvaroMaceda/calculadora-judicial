def benchmark
    start = Time.now
    yield
    Time.now - start # Returns time taken to perform func
end

def confirm(message)
    puts message
    print "Enter 'yes' to confirm: "
    input = STDIN.gets.chomp
    return input == 'yes'
end