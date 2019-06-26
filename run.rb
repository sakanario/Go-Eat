require_relative 'back_end/logic'
require_relative 'back_end/module'
include Go
File.open("log.txt", "w") { |f| f.write "History\n" }

#initialize map 
v1 = ARGV[0].to_i
v2 = ARGV[1].to_i
v3 = ARGV[2].to_i
peta = Map.new(v1,v2,v3)
ARGV.clear

# p ARGV
# peta = Map.new(10,1,1)

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
    #hapus driver rating jelek
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

        #import menu
        menu = menu_toko(y)
        
        #ongkos kirim
        ongkir =  peta.closest_driver(y) * 3000

        #menu in the picked store
        z = 0
        amount = Hash.new{0}
        total = 0
        while z.to_i != 2
            availible_item(menu)
    
            print "\nChoose menu : "
            pick = gets.chomp
            
            #asking amount
            print "amount of the item : "
            temp = gets.chomp
            amount["#{menu[pick.to_i-1][0]}"] = amount["#{menu[pick.to_i-1][0]}"] + temp.to_i

            #keeping order
            order["#{menu[pick.to_i-1][0]}"] = [ menu[pick.to_i-1][1] , amount["#{menu[pick.to_i-1][0]}"] ]
            
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
        peta.journey(y)

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
        #membuka file log.txt
        file = File.open("log.txt")
        file_data = file.read
        puts file_data
    when 4 
        puts "Program Exited, Bye!"
    else
        puts "Wrong input, please try again."
    end
    
    
end
File.delete('log.txt') if File.exist?('log.txt')
