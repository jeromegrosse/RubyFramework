require 'liquid'

module JFW
    class Renderer
        attr_accessor :main

        def initialize
            @variables = Hash.new
            @variables[:title] = ''
            Liquid::Template.file_system = Liquid::LocalFileSystem.new(@@APP_FOLDER + "app/views/")
        end


        def set name, value
            @variables[name] = value
        end


        def render
            file_data = File.read(@@APP_FOLDER + "app/views/" + main)
            template  = Liquid::Template.parse(file_data)
            template.render(@variables)
        end

    end
end
