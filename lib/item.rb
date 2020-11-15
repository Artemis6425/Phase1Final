class ITEM
    @@all = []
    def initialize(name, value)
        @name = name
        @value = value
        @@all << self
    end
    attr_accessor :name, :value
    def self.all
        @@all
    end
end