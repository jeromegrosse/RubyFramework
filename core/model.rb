class Model
    attr_accessor :id

    @id
    @table
    @connection
    @properties

    @logger

    def initialize
        @table  = ""
        @logger = Logger.new('log/app.log')
        property_definition
    end


    def save
        property = @properties
        sql = _query_save
        log "debug", sql
        _connect_db
        @connection.query sql
        _disconnect_db
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
    def _query_save
        properties = @properties
        properties.delete('id') if @id.nil?

        sql  = @id.nil? ? "INSERT INTO " : "UPDATE "
        sql += @table + " "
        sql += "(" + properties.join(', ') + " ) VALUES ( "
        sql  =  properties.inject(sql) do |sql, property|
                    if(property.nil? || property == "id")
                        sql
                    else
                        sql + "'" + instance_variable_get("@#{property}").to_s.gsub(/[^\w\.\-\:\+\s]/,"_") + "'" +  (property == @properties.last ? "" : ", ")
                    end
                end
        sql += " )"
    end


    def property_definition
        @properties = []
    end


    def log(tag = "info", message = "")
        @logger.info(tag) { message }
    end
end