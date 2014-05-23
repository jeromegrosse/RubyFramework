class Factory
    @object_name
    @table
    @connection
    @properties

    @logger

    def initialize
        @table  = ""
    end


    def find id
        sql = _sql_find id
        _connect_db
        result = @connection.query sql
        log "test", result
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
            row.each do |key,value|
                object.instance_variable_set("@#{key}", value) if(object.property_definition.include? key)
            end
        end

        return object
    end


    def log(tag = "info", message = "")
        @logger = Logger.new('log/app.log') if @logger.nil?

        @logger.info(tag) { message }
    end
end