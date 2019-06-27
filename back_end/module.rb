module Go
    def list_of_store(store)
        @store = store
        puts "\nList of Store :"
        count = 1
        @store.each do |val|
            puts "#{count}. #{val}"
            count += 1
        end
    end

    def availible_item(menu)
        puts "\nStore’s available item(s)"
        puts "Product's Name\t\tPrice"
        
        count = 1
        menu.each do |val|
            puts "#{count}. #{val[0]}\t\t#{val[1]}"
            count += 1
        end
    end

    def inisiasi_toko
        f = open('file_data/store_name.txt')
        store = []
        f.each_line { |line| store << line }
        f.close
        store
    end

    def menu_toko(y)
        f = File.open("store_menu/#{y}.txt", "r")
        c = 0
        menu = []
        f.each_line do |line|
            menu[c] = []
            menu[c] << line.split(',')[0]
            menu[c] << line.split(',')[1]
            c += 1
        end
        f.close
        menu
    end

    def ask_driver_rating
        cek = false
            while cek == false
                puts "\nHow Driver performance? "
                print "Rating : "
    
                rate = gets.chomp.to_i
                if (rate < 1 || rate > 5)
                    puts "give rating 1 - 5!"
                else
                    cek = true
                end
            end
        rate
    end


end