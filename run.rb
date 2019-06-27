require_relative 'back_end/logic'
require_relative 'back_end/module'
include Go
File.open("log.txt", "w") { |f| f.write "\nHistory\n" }
File.open("route.txt", "w") { |f| f.write "\nRoute\n" }

#initialize map 
if ARGV.empty?
    peta = Map.new(20)
else
    v1 = ARGV[0].to_i
    v2 = ARGV[1].to_i
    v3 = ARGV[2].to_i
    peta = Map.new(v1,v2,v3)
    ARGV.clear
end

puts "Welcome at Go-Eat"
sleep(0.1)

#initialize hash for keeping order
order = Hash.new

# nama toko
inisiasi_toko()
store = inisiasi_toko()

# main program
x = 0
while x.to_i != 4
    #hapus driver dgn rating jelek
    peta.bad_driver

    puts "\nMenu : "
    puts "1.Show Map\n2.Order Food\n3.View History\n4.Quit"
    
    print "\nChoose menu : "
    x = gets.chomp.to_i
    
    case x
    when 1
        puts ""
        peta.display
    when 2
        # pilih toko
        list_of_store(store)
        print "\nChoose menu : "
        y = gets.chomp.to_i

        #generate toko's menu
        menu = menu_toko(y)
        
        #ongkos kirim
        ongkir =  peta.closest_driver(y) * 300

        #menu in the picked store
        z = 0
        amount = Hash.new{0}
        total = 0
        while z.to_i != 2
            availible_item(menu)
    
            print "\nChoose menu : "
            pick = gets.chomp.to_i
            
            #asking amount
            print "amount of the item : "
            temp = gets.chomp.to_i
            amount["#{menu[pick.to_i-1][0]}"] = amount["#{menu[pick.to_i-1][0]}"] + temp

            #keeping order
            order["#{menu[pick-1][0]}"] = [ menu[pick-1][1] , amount["#{menu[pick-1][0]}"] ]
            
            #asking if_done
            puts "\n1. Add more item\n2. Finish the order"
            print "\nChoose menu : "
            z = gets.chomp
        end
        
        #telling order
        # print order
        puts "\nBills :"
        puts "Product's Name\tAmount\tPrice"
        order.each do |key,val|
            puts "#{key}\t#{val[1]}\t#{val[0]}"
            total = total + (val[0].to_i * val[1])
        end
        puts "\nDelivery fee\t\t#{ongkir}"
        puts "Total\t\t\t#{total + ongkir}"

        # got a driver message
        peta.looking_driver

        # perjalanan driver
        peta.journey(y,store[y-1])

        # Give driver a rating
        rate = ask_driver_rating()

        # rating the driver
        peta.rating(rate)
        # peta.show_driver_rating

        #keep the log
        File.open("log.txt", "a") { |f| f.write "\n#{Time.now}\n" }
        File.open("log.txt", "a") { |f| f.write "Nama Toko : #{store[y-1]}\n" }
        File.open("log.txt", "a") { |f| f.write "Product's Name\tAmount\tPrice\n" }
        order.each do |key,val|
            File.open("log.txt", "a") { |f| f.write "\n#{key}\t#{val[1]}\t#{val[0]}\n" }
            order.delete(key)
        end
        File.open("log.txt", "a") { |f| f.write "-"*30 }
        File.open("log.txt", "a") { |f| f.write "\nDelivery fee\t\t#{ongkir}" }
        File.open("log.txt", "a") { |f| f.write "\nTotal\t\t\t#{total + ongkir}\n" }

    when 3
        puts "\n1. Transaction history\n2. Driver History"
        print "\nChoose menu : "
        v = gets.chomp.to_i
        if v == 1
            #membuka file log.txt
            file = File.open("log.txt")
            file_data = file.read
            puts file_data
        elsif v == 2
            #membuka file route.txt
            file = File.open("route.txt")
            file_data = file.read
            puts file_data
        end
    when 4 
        puts "Program Exited, Bye!"
    else
        puts "Wrong input, please try again."
    end
    
    
end
File.delete('log.txt') if File.exist?('log.txt')
