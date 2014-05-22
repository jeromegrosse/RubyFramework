require 'liquid'

class Renderer
    attr_accessor :content

    def initialize
        @variables = Hash.new
        @variables[:title] = ''
    end

    def set name, value
        @variables[name] = value
    end

    def render
        file_data = File.read(@@APP_FOLDER + "app/views/" + content)
        template  = Liquid::Template.parse(file_data)
        template.render(@variables)
    end

end