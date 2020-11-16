class CLI   #probably split some of these commands into different files for ease of use
    def start
        puts "==Welcome to Exile's First Price Checking Utility! (A Path of Exile tool)=="
        puts "\n"
        #sleep(1)           These sleep commands fit thematically for speaking time, removed for faster testing
        puts "There are many items one may find around these parts."
        #sleep(2)
        puts "This tool aims to help you figure out how much your gear may be worth."
        #sleep(2)
        puts "My name is Nessa. How can I help you this evening here in Lioneye's Watch?"
        #sleep(2)
        @exile = USER.new
        mainmenu
    end
    @@searched = {
        "Fossil" => 0,
        "Incubator" => 0,
        "Resonator" => 0,
        "Scarab" => 0,
        "Fragment" => 0,
        "Currency" => 0
    }
    def mainmenu
        testprompt = TTY::Prompt.new
        userinput = testprompt.select("") do |menu|
            menu.choice "Price Check Item",1
            menu.choice "Total Value of My Items",3
            menu.choice "Exit Lioneye's Watch",2
        end
        #userinput = self.maininput
        if userinput == 2
            exit_program
        elsif userinput == 3
            quickvalue
        end
        secondmenu
        return
    end

    def secondmenu
        puts "\n"
        puts "Alright, I can help with that. What kind of item is it?"
        testprompt = TTY::Prompt.new
        userinput = testprompt.select("") do |menu|
            menu.choice "Fossil","Fossil"
            menu.choice "Incubator","Incubator"
            menu.choice "Resonator","Resonator"
            menu.choice "Scarab","Scarab"
            menu.choice "Fragment","Fragment"
            menu.choice "Currency","Currency"
            menu.choice "I misspoke, sorry!","back"
        end
        if userinput == "back"
            puts "\n"
            puts "If you say so. Anything else?"
            mainmenu
        end
        thirdmenu(userinput)
        return
    end

    def thirdmenu(userinput)
        puts "\n"
        puts "What kind of #{userinput} item did you say it was, again?"
        puts "(Enter the name of the #{userinput})"
        self.thirdinput(userinput)
        mainmenu
    end

    def thirdinput(userinput)
        input = gets.strip.capitalize
        @@searched[userinput] +=1
        @found = 0
        i=0
        if input == ""
            puts "Could you speak up? I didn't catch that."
            thirdinput(userinput)
            return
        elsif input == "Chaos" || input == "Chaos Orb"
            puts "\n"
            puts "Chaos are the default curreny of this place. It's worth one of itself."
            puts "Anything else?"
            return
        end
        if @@searched[userinput] != 1 #This if statement makes sure you don't bother the api too much
            iterateitemandsave(input)
            mainmenu
            return
        else
            itemlist = API.fetch_thing(userinput)
            if API.type == "item"
                #puts "api called"
                itemlist.each do |item|
                    ITEM.new(item['name'],item['chaosValue'].round(1))
                    if item['name'].include?(input)
                        @itemname = item['name']
                        @itemvalue = item['chaosValue'].round(1)
                        @found = 1
                    end
                    i+=1
                end
                if @found == 0
                    puts "\n"
                    puts "I'm not finding any of those."
                    thirdmenu(userinput)
                    mainmenu
                    return
                end
                iterateitemandsave(input)
                return
            elsif API.type == "currency"
                #puts "api called"
                itemlist.each do |item|
                    ITEM.new(item['currencyTypeName'],item['receive']['value'].round(1))
                    if item['currencyTypeName'].include?(input)
                        @itemname = item['currencyTypeName']
                        @itemvalue = item['receive']['value'].round(1)
                        @found = 1
                    end
                    i+=1
                end
                if @found == 0
                    puts "\n"
                    puts "I'm not finding any of those."
                    thirdmenu(userinput)
                    return
                end
                iterateitemandsave(input)
                return
            end
        end
    end

    def putsitemvalue
        puts "\n"
        puts "Hmm... it looks like your #{@itemname} is worth #{@itemvalue} chaos."
        puts "I'm not looking to buy any, but I'm sure there's other exiles that woud love #{@itemname}s."
        puts "\n"
        puts "How many did you have? I'm trying to keep a total."
        temp = gets.strip.to_i
        puts "\n"
        puts "Is there anything else I can help you with?"
        return temp
    end

    def iterateitemandsave(input)
        ITEM.all.select do |temp|
            if temp.name.include?(input)
                @itemname = temp.name
                @itemvalue = temp.value
                @found = 1
                idea = putsitemvalue
                @exile.additem(temp.name, temp.value, idea)
                mainmenu
            end
        end
        if @found == 0
            puts "\n"
            puts "I couldn't find those. I think its best we restart."
            mainmenu
            return
        end
    end

    def quickvalue
        if @exile.items.empty?
            puts "\n"
            puts "I haven't valued anything for you yet."
            mainmenu
            return
        end
        puts "\n"
        puts "Here's the list I have so far:"
        i=0
        @exile.items.each do |temp| #its always temp :)
            i += temp.count*temp.value
            puts "You have #{temp.count} #{temp.name}s with a total value of #{temp.count*temp.value} chaos"
        end
        puts "The total value of everything you have is #{i.round(1)} chaos."
        puts "\n"
        puts "Is there anything else I can do for you this evening?"
        mainmenu
        return
    end

    def exit_program
        puts "\n"
        puts "Farewell, exile."
        exit
    end
end