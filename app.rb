require "sinatra"
require "json-schema"

schema = File.read("schema.json")

helpers do
  def format_error_message(msg)
    CGI.escapeHTML(msg)
      .squeeze("\n")
      .gsub(/^[ ]+/) { |s| "&nbsp;" * s.length }
      .gsub(Regexp.new('in schema [-#\w]+$'), "")
      .gsub(/\n/, "<br>")
  end
end

get "/" do
  @data = ""
  @errors = []

  erb :index, layout: :layout
end

post "/validate" do
  @data = params[:data]

  begin
    @data = JSON.pretty_generate(JSON.parse(@data))
    @errors = JSON::Validator.fully_validate(schema, @data)
  rescue => ex
    @errors = [ex.message]
  end

  erb :index, layout: :layout
end
