class API
    @@type = "?"
    def self.fetch_thing(thing)
        if ["Fossil", "Incubator", "Resonator", "Scarab"].include?(thing)
            @@type = "item"
            parse = URI.parse("https://poe.ninja/api/data/itemoverview?league=Heist&type=#{thing}")
            response = Net::HTTP.get_response(parse)
            tempvar = JSON.parse(response.body)
            tempvar = tempvar['lines']
            return tempvar
        elsif ["Fragment", "Currency"].include?(thing)
            @@type = "currency"
            parse = URI.parse("https://poe.ninja/api/data/currencyoverview?league=Heist&type=#{thing}")
            response = Net::HTTP.get_response(parse)
            tempvar = JSON.parse(response.body)
            tempvar = tempvar['lines']
            return tempvar
        end
    end
    def self.type
        @@type
    end
end