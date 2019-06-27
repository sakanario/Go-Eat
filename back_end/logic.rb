require_relative 'module'
include Go

class Map
    def initialize(n=20,x=nil,y=nil)
        @length = n
        @width = n
        @map = Hash.new {[:empty]}
        @driver = Hash.new{[:empty]}
        @store = Hash.new{[:empty]}
        @user = Hash.new{[:empty]}
        @driver_name = Hash.new
        @driver_rating = Hash.new{[0,0]}

        
        self.user_location(@map,x,y)
        self.driver_location
        self.store_location(@map)
    end

    def to_market(x1,y1,x2,y2)

        print "\ndriver is on the way to store, start at (#{x2},#{y2})"
        File.open("route.txt", "a") { |f| f.write "\ndriver is on the way to store, start at (#{x2},#{y2})" }
        
        sleep(0.1)
        # vertikal
        until y2 == y1
            if(y2 > y1)
                y2 = y2 -1
            end

            if (y2 < y1)
                y2 = y2 + 1
            end

            print "\ngo to (#{x2},#{y2})"
            File.open("route.txt", "a") { |f| f.write "\ngo to (#{x2},#{y2})"}
            sleep(0.1)

            if (x2 == x1 && y2 == y1)
                puts "driver arrived at the store!"
                File.open("route.txt", "a") { |f| f.write "driver arrived at the store!"}
                
                sleep(0.1)

            end
        end

        # horizontal
        until x2 == x1
            if(x2 > x1)
                x2 = x2 -1
            end
            if (x2 < x1)
                x2 = x2 + 1
            end
            
            print "\ngo to (#{x2},#{y2})"
            File.open("route.txt", "a") { |f| f.write "\ngo to (#{x2},#{y2})" }

            sleep(0.1)

            if (x2 == x1 && y2 == y1)
                puts ", driver arrived at the store!"
                File.open("route.txt", "a") { |f| f.write ", driver arrived at the store!" }
                sleep(0.1)

            end
        end
        @x2 = x2
        @y2 = y2
    end

    def to_user(x1,y1,x2,y2)

        print "driver has bought the item(s), start at (#{x2},#{y2})"
        File.open("route.txt", "a") { |f| f.write "\ndriver has bought the item(s), start at (#{x2},#{y2})" }

        sleep(0.1)

        # vertikal
        until y2 == y1
            if(y2 > y1)
                y2 = y2 -1
            end

            if (y2 < y1)
                y2 = y2 + 1
            end

            print "\ngo to (#{x2},#{y2})"
            File.open("route.txt", "a") { |f| f.write "\ngo to (#{x2},#{y2})" }
            sleep(0.1)

            if (x2 == x1 && y2 == y1)
                puts ", driver arrived at your place!"
                File.open("route.txt", "a") { |f| f.write ", driver arrived at your place!" }
                sleep(0.1)

            end
        end

        # horizontal
        until x2 == x1
            if(x2 > x1)
                x2 = x2 -1
            end
            if (x2 < x1)
                x2 = x2 + 1
            end
            
            print "\ngo to (#{x2},#{y2})"
            File.open("route.txt", "a") { |f| f.write "\ngo to (#{x2},#{y2})" }
            sleep(0.1)

            if (x2 == x1 && y2 == y1)
                puts ", driver arrived at your place!"
                File.open("route.txt", "a") { |f| f.write ", driver arrived at your place!" }
                sleep(0.1)
            end
            # @x2 = x2
            # @y2 = y2
        end
        # @map[[x2,y2]] = "D#{@count}"
    end

    def journey(store_code,store_name)
        File.open("log.txt", "a") { |f| f.write "\n#{Time.now}" }
        File.open("route.txt", "a") { |f| f.write "\nDriver Name : #{@driver_name[@active_diver]}" }
        File.open("route.txt", "a") { |f| f.write "Order to : #{store_name}" }

        # toko's kordinat 
        @help =  @store.to_a 
        x1 = @help[store_code-1][1][0]
        y1 = @help[store_code-1][1][1]

        # driver's kordinate
        x2 =  @driver[@active_diver][0]
        y2 = @driver[@active_diver][1]

        #user's kordinate
        x3 = @user["Your Location"][0]
        y3 = @user["Your Location"][1]

        self.to_market(x1,y1,x2,y2)
        self.to_user(x3,y3,@x2,@y2)
    end

    def rating(val)
        # count
        @driver_rating[@active_diver][0] += 1

        #total point
        @driver_rating[@active_diver][1] += val.to_f
    end

    def show_driver_rating
        x = @driver_rating[@active_diver][1].to_f
        y = @driver_rating[@active_diver][0].to_f
        
        if y == 0
            rate = 0.0
        else
            rate = x/y 
            
        end

        rate
    end

    def show_all_driver_rating
        @driver_rating.each do |key,val|
            if val[0] == 0
                puts "#{key} rating is nil"
            else
                puts "#{key} rating is #{(val[1].to_i/val[0].to_f)}"
            end
        end
    end

    def bad_driver
        count = 0
        @driver_rating.each do |key,val|
            if val[0] > 0
                if (val[1].to_i/val[0]).to_f < 3.0
                    #delete from map
                    @map[@driver[key]] = [:empty]
                    
                    #delete metadata
                    @driver.delete(key)

                    #delete rating
                    @driver_rating.delete(key)
                end
            end
        end

        @driver_rating.each do |key,val|
            count += 1
        end

        if (count == 0)
            puts "\nlooking for drivers!"
            self.driver_location
        end
    end

    def closest_driver(store_code)
        @help =  @store.to_a 
        # toko's kordinat 
        x1 = @help[store_code-1][1][0]
        y1 = @help[store_code-1][1][1]

        close = ''
        min = nil
        @driver.each do|key,value|

            x2 = value[0]
            y2 = value[1]
            
            x = (x1 - x2).abs  
            y = (y1 - y2).abs

            distance = x + y

            if (min == nil)
                min = distance 
            end

            if (distance <= min)
                min = distance 
                close = key
            end
        end

        # jarak toko ke user 
        x2 = @user["Your Location"][0]
        y2 = @user["Your Location"][1]
        
        x = (x1 - x2).abs  
        y = (y1 - y2).abs

        distance = x + y
        
        @active_diver = close
        # @active_diver_number = 
        total = distance + min
        total
    end

    def user_location(map,x=nil,y=nil)
        @map = map
        if(x != nil && y != nil)
            @map[[x,y]] = "U"
            @user["Your Location"] = [x,y]
        else
            @count = 1
            until @count == 2
                i = rand(1..@length)
                j = rand(1..@width)
                if map[[i,j]] == [:empty]
                    map[[i,j]] = "U"
                    @user["Your Location"] = [i,j]
                    @count += 1
                end
            end
        end
    end

    def driver_location
        
        @count = 1
        until @count == 6
            i = rand(1..@length)
            j = rand(1..@width)
            if @map[[i,j]] == [:empty]
                @map[[i,j]] = "D#{@count}"
                @driver["Driver #{@count}"] = [i,j]
                @driver_rating["Driver #{@count}"] = [0,0]
                @count += 1
            end
        end

        f = open('file_data/driver_name.txt')
        temp = []
        f.each_line { |line| temp << line }
        f.close

        for i in 1..5 do
            @driver_name["Driver #{i}"] = temp[i-1]
        end

    end

    def store_location(map)
        toko = inisiasi_toko()
        @map = map
        count = 1
        until count == 4
            i = rand(1..@length)
            j = rand(1..@width)
            if map[[i,j]] == [:empty]
                map[[i,j]] = "S#{count}"
                # p "di store location #{toko[count-1]}"
                temp = toko[count-1]
                temp.gsub! "\n" , ""
                @store["#{temp}"] = [i,j]
                # @store["Store #{@count}"] = [i,j]
                count += 1
            end
        end
    end

    def show_driver_location
        c = 1
        @driver.each do|key,value|
            
            puts "#{key} (D#{c})\t\t: (#{value[0]},#{value[1]})"
            c += 1
        end
    end

    def show_store_location
        # print @store
        c = 1
        @store.each do|key,value|
            # puts key.length
            if key.length < 11 
                puts "#{key} (S#{c})\t\t: (#{value[0]},#{value[1]})"
            else
                puts "#{key} (S#{c})\t: (#{value[0]},#{value[1]})"
            end
            c +=1
        end
    end

    def show_user_location
        @user.each do|key,value|
            puts "#{key} (U)\t: (#{value[0]},#{value[1]})"
        end
    end
    
    def display
        self.show_user_location
        puts "\nDriver location"
        self.show_driver_location
        puts ""
        puts "Store location"
        self.show_store_location
        
        # 2D Map Simulation
        print "    "
        for j in 1..@width do
            if j > 9
                print "#{j}   "
                
            else
                print "#{j}    "
                
            end
        end
        puts ''
        for i in 1..@length do
            print "_" * (51 * (@width.to_f/10))
            puts ""

            if i < 10
                print " #{i}"
            else
                print "#{i}"
            end

            for j in 1..@width do
                if @map[[i,j]] == [:empty]
                    print "|    "
                else
                    if @map[[i,j]] == "U"
                        print "| #{@map[[i,j]]}  "
                    else
                        print "| #{@map[[i,j]]} "
                    end
                end
            end
            print "|\n"
        end
        print "_" * (51 * (@width.to_f/10))
    end

    def looking_driver
        print "\nlooking for driver"
        3.times do
            sleep(0.5)
            print "."
        end

        puts "\n\nHey you got a driver!"
        puts "Name : #{@driver_name[@active_diver]}"
        puts "Rating : #{show_driver_rating}\n"
        sleep(0.25)
    end

end

# peta = Map.new(10,10)
# peta.bad_driver