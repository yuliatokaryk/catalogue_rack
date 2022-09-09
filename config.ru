class App

  def call(env)
    status = 200
    headers = { 'Content-Type' => 'text/plain' }
    body = ['Hello World hhh']
    
    [status, headers, body]
  end

end

run App.new
