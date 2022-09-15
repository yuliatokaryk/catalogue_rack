require 'pg'
require 'json'
require 'pry'

class Database
  def call
    PG.connect( dbname: 'catalogue_db', user: 'postgres', password: 'postgres' )
  end
end

class App

  def call(env)
    conn = Database.new.call
    path = env['REQUEST_PATH']
    method = env['REQUEST_METHOD']

    if path == '/' && method == 'GET'
      status = 200
      headers = { 'Content-Type' => 'text/plain' }
      body = ['Hello World']
    elsif ['/items', '/items/'].include?(path) && method == 'GET'
      status = 200
      headers = { 'Content-Type' => 'application/json' }
      body = [conn.exec('select * from items').values.to_json]
    elsif ['/items', '/items/'].include?(path) && method == 'POST'
      status = 201
      params = Rack::Utils.parse_nested_query(env['QUERY_STRING'])
      name = params['name']
      description = params['description']
      conn.exec("INSERT INTO items (name, description) VALUES ('#{name}', '#{description}');")
      headers = { 'Content-Type' => 'application/json' }
      body = [conn.exec('select *from items ORDER BY id DESC LIMIT 1;').values.to_json]
    else
      status = 404
      headers = { 'Content-Type' => 'text/plain' }
      body = ['Error 404']
    end

    [status, headers, body]
  end

end

run App.new
