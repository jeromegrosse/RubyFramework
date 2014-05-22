require 'yui/compressor'
require 'digest/sha1'

class Global < BaseController
    def favicon
        path = @@APP_FOLDER + "statics/images/favicon.jpeg"
        favicon_data = File.read(File.dirname(__FILE__) + "/../../statics/images/favicon.jpeg")

        Response.new.tap do |response|
            response.body         = favicon_data
            response.headers      = {'Content-Type'  => "image/jpeg"}
            response.status_code  = 200
        end
    end

    def error_404
        Response.new.tap do |response|
            response.body         = "404 - Not found"
            response.status_code  = 404
        end
    end

    def fonts
        font_name = @env["PATH_INFO"].split(/\//).last
        path = @@APP_FOLDER + "statics/fonts/" + font_name

        code = 404
        content = ""

        if File.exist?(path)
            code = 200
            content = File.read(path)
        end

        Response.new.tap do |response|
            response.body         = content
            response.status_code  = code
        end

    end


    def style_css
        arr_css = _get_css_filename
        css     = arr_css.inject("") { |memo, file| memo + File.read(@@APP_FOLDER + file) }

        hash    = Digest::SHA1.hexdigest css
        cache_path = @@APP_FOLDER + "cache/css/" + hash + ".css"

        # Check if there is already a compressed css file in the cache
        if File.exist?(cache_path)
            compressed_css = File.read(cache_path)
        else
            compressor     = YUI::CssCompressor.new
            compressed_css = compressor.compress(css)

            f = File.open(cache_path, "w"){ |file| file.write(compressed_css) }
        end

        Response.new.tap do |response|
            response.body         = compressed_css
            response.headers      = {'Content-Type'  => "text/css"}
            response.status_code  = 200
        end
    end


    def scripts_js
        arr_js = _get_js_filename
        js     = arr_js.inject("") { |memo, file| memo + File.read(@@APP_FOLDER + file) }

        hash    = Digest::SHA1.hexdigest js
        cache_path = @@APP_FOLDER + "cache/js/" + hash + ".js"

        # Check if there is already a compressed css file in the cache
        if File.exist?(cache_path)
            compressed_js = File.read(cache_path)
        else
            compressor     = YUI::JavaScriptCompressor.new
            compressed_js = compressor.compress(js)

            File.open(cache_path, "w"){ |file| file.write(compressed_js) }
        end

        Response.new.tap do |response|
            response.body         = compressed_js
            response.headers      = {'Content-Type'  => "text/javascript"}
            response.status_code  = 200
        end
    end



    private
    def _get_css_filename
        return [
            "statics/css/style.css",
        ]
    end

    private
    def _get_js_filename
        return []
    end
end