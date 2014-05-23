class Factory
    @object_name
    @table
    @connection
    @properties

    @logger

    def initialize
        @table  = ""
        @logger = Logger.new('log/app.log')
    end


    # def save
    #     property = @properties
    #     sql = _query_save
    #     log "debug", sql
    #     _connect_db
    #     @connection.query sql
    #     _disconnect_db
    # end

    def find id
        sql = _sql_find id
        log "debug", sql
        _connect_db
        result = @connection.query sql
        log "find rest", result
        _disconnect_db

        return _build_object result
    end


    private
    def _connect_db
        config_path = @@APP_FOLDER + "config/database.yml";
        db_config   = YAML.load(File.read(config_path))
        @connection = Mysql2::Client.new(:host => db_config['db_host'], :username => db_config['db_user'], :password => db_config['db_password'], :database => db_config['db_name'])
    end


    private
    def _disconnect_db
    end

    private
    def _sql_find id
        "SELECT * FROM #{@table} WHERE id = #{id}"
    end

    private
    def _build_object data
        object_meta = Object.const_get(@object_name)
        object      = object_meta.new

        data.each do |row|
            log "factory", row
            row.each do |key,value|
                log "factory", "#{key} and #{value}"
                log "facotry", "#{object.property_definition.include? key}"
                object.instance_variable_set("@#{key}", value) if(object.property_definition.include? key)
            end
        end

        return object
    end


    def log(tag = "info", message = "")
        @logger.info(tag) { message }
    end
end