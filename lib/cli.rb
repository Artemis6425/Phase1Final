class CLI   #probably split some of these commands into different files for ease of use
    def start
        puts "==Welcome to Exile's First Price Checking Utility (A Path of Exile tool)!=="
        puts "\n"
        #sleep(1)           These sleep commands fit thematically for speaking time, removed for faster testing
        puts "There are many items one may find around these parts."
        #sleep(2)
        puts "This tool aims to help you figure out how much your gear may be worth."
        #sleep(2)
        puts "My name is Nessa. How can I help you this evening here in Lioneye's Watch?"
        #sleep(2)
        mainmenu
    end

    def mainmenu
        testprompt = TTY::Prompt.new
        userinput = testprompt.select("") do |menu|
            menu.choice "Price Check Item",1
            menu.choice "Exit Lioneye's Watch",2
        end
        #userinput = self.maininput
        if userinput == 2
            exit_program
        end
        secondmenu
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
    end

    def thirdmenu(userinput)
        puts "\n"
        puts "What kind of #{userinput} item did you say it was, again?"
        puts "(Enter the name of the #{userinput})"
        self.thirdinput(userinput)
        puts "\n"
        puts "Hmm... it looks like your #{@itemname} is worth #{@itemvalue} chaos."
        puts "I'm not looking to buy any, but I'm sure there's other exiles that woud love #{@itemname}s."
        puts "\n"
        puts "Is there anything else I can help you with?"
        mainmenu
    end

    def thirdinput(userinput)
        input = gets.strip  
        @found = 0
        i=0
        if input == ""
            puts "Could you speak up? I didn't catch that."
            thirdinput(userinput)
            return
        end
        if ITEM.all.select do |temp|
            if temp.name.include?(input)
                @itemname = temp.name
                @itemvalue = temp.value
                puts "success?!"
                return
            end
        end
        itemlist = API.fetch_thing(userinput)
        if API.type == "item"
            itemlist.each do |item|
                ITEM.new(item['name'],item['chaosValue'])
                if item['name'].include?(input)
                    @itemname = item['name']
                    @itemvalue = item['chaosValue'].round(1)
                    @found = 1
                    puts "api called"
                end
                i+=1
            end
        elsif API.type == "currency"
            itemlist.each do |item|
                if item['currencyTypeName'].include?(input)
                    @itemname = item['currencyTypeName']
                    @itemvalue = item['receive']['value'].round(1)
                end
                @found = 1
            end
            i+=1
        end
        if @found == 0
            puts "\n"
            puts "I'm not finding any of those."
            thirdmenu(userinput)
        end
    end
    end #I don't get why i need this, I think I counted correctly

    def exit_program
        puts "\n"
        puts "Farewell, exile."
        exit
    end
end