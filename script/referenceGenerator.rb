# Updates API documentation. Run with:

# # Generate sample output (use as a dry run)
# bundle exec ruby referenceGenerator.rb

# # Only act on a single model
# bundle exec ruby referenceGenerator.rb --file=status.rb

# # Send updates to API documentation
# bundle exec ruby referenceGenerator.rb --update-api

# # All together
# bundle exec ruby referenceGenerator.rb --update-api --file=status.rb

require 'yard'
require 'multi_json'
require '../lib/podio'

operations = {}
path = '*.rb'
update_api = false
ARGV.each do |arg|
  if arg.match('--file=')
    path = arg.sub('--file=', '')
  elsif arg == '--update-api'
    update_api = true
  end
end

YARD.parse("../lib/podio/models/#{path}")

YARD::Registry.all(:class).each do |klass|
  klass.meths(:visibility => :public).each do |meth|
    link = meth.tag('see').name if meth.has_tag?('see')
    match = link.match(/https:\/\/developers.podio.com\/doc\/(.+)-([0-9]+)/) if link
    if match
      item_id = match[2].to_i

      # Build example string
      param_string = ''
      param_list = []
      meth.parameters.each do |p|
        if p[1]
          param_list << "#{p[0]} = #{p[1]}"
        else
          param_list << p[0]
        end
      end
      param_string = "( #{param_list.join(', ')} )" if param_list.length > 0

      if meth.scope == :class
        example_string = "Podio::#{klass.name}.#{meth.name}#{param_string}"
      else
        example_string = "#{klass.name.downcase}.#{meth.name}#{param_string}"
      end


      data = {
        :className => klass.name,
        :method => meth.name,
        :path => "models/"+File.basename(meth.files.first.first),
        :line => meth.files.first.last,
        :type => meth.scope == :class ? 'static' : 'instance',
        :example => example_string,
      }
      operations[item_id] = [] if !operations[item_id]
      operations[item_id] << data
    end
  end
end

if update_api
  require './config.rb'
  Podio.setup(:api_key => PODIO_SETUP[:client_id], :api_secret => PODIO_SETUP[:client_secret])
  Podio.client.authenticate_with_app(PODIO_SETUP[:app_id], PODIO_SETUP[:app_token])
  operations.each do |item_id, data|
    puts "Updating #{item_id}"
    encoded_data = MultiJson.encode(data)
    begin
      Podio::ItemField.update(item_id, 16359339, {:value => encoded_data}, {:silent => true})
    rescue Podio::GoneError
      puts "    PodioGoneError for this item id"
    end
  end
else
  puts operations
end
