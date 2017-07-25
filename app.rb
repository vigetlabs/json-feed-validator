require "sinatra"
require "json-schema"

schema = File.read("schema.json")

get "/" do
  erb :index
end

post "/validate" do
  @data = params[:data]

  begin
    @errors = JSON::Validator.fully_validate(schema, @data)

    if @errors.none?
      @data = JSON.pretty_generate(JSON.parse(@data))
    end
  rescue => ex
    @errors = [ex.message]
  end

  erb :validate
end
