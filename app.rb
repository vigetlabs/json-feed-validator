require "sinatra"
require "json-schema"

schema = File.read("schema.json")

get "/" do
  @data = ""
  @errors = []

  erb :index, layout: :layout
end

post "/validate" do
  @data = params[:data]

  begin
    JSON.parse(@data)

    @errors = JSON::Validator.fully_validate(schema, @data)
    @data = JSON.pretty_generate(JSON.parse(@data))
  rescue => ex
    @errors = [ex.message]
  end

  erb :index, layout: :layout
end
