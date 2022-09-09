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
    status = 200
    headers = { 'Content-Type' => 'application/json' }
    body = [conn.exec('select * from items').values.to_json]

    [status, headers, body]
  end

end

run App.new
