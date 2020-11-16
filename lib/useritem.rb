class USERITEM
    def initialize(item, count, value, exile)
        @name = item
        @count = count
        @value = value
        @exile = exile
    end
    attr_accessor :name, :count, :exile, :value
end