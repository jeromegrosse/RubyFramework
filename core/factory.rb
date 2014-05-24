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

        return _build_object result
    end


    def find_all arr_condition = [], pagination = {:offset=>0, :per_page=>20}
        sql = _sql_find_all arr_condition, pagination
        _connect_db
        result = @connection.query sql
        _disconnect_db


    end


    def log(tag = "info", message = "")
        @logger = Logger.new('log/app.log') if @logger.nil?

        @logger.info(tag) { message }
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
    def _sql_find_all arr_condition, pagination
        sql = "SELECT * FROM #{@table} "
        sql += "WHERE " if arr_condition.length > 0
        arr_condition.each do |key, value|
            sql += key
            sql += value.kind_of?(Array) ? " IN ( #{value.join(', ')} ) " : " = #{value} "
            sql += "AND "
        end

        #Dirty fix that erase all "AND " in the last of the string
        sql = sql[0..-5] if sql[sql.length - 4, sql.length] == "AND "
        sql += "LIMIT #{pagination[:offset]}, #{pagination[:per_page]}"
    end


    private
    def _build_object data
        object_meta = Object.const_get(@object_name)
        arr_object  = []

        data.each do |row|
            object = object_meta.new
            row.each do |key,value|
                object.instance_variable_set("@#{key}", value) if(object.property_definition.include? key)
            end
            arr_object << object
        end

        ret = nil
        if arr_object.length == 1
            ret = arr_object[0]
        elsif arr_object.length > 1
            ret = arr_object
        end

        return ret
    end
end