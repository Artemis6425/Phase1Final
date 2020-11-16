class USER
    def initialize
        @items = []
    end
    def additem(item, value, count)
        temp = USERITEM.new(item, count, value, self)
        @items << temp
    end
    attr_accessor :items
end