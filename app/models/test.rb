class Test < Model

    attr_accessor :table, :value, :date

    @value
    @date

    def initialize
        super
        @table = 'test'
    end

    private
    def _property_definition
        @properties = ['id', 'value', 'date']
    end

end