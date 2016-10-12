require 'json'

class Session

  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    # puts "the session is #{@session}"
    # puts "session[xyz] is #{@session['xyz']}"
    # puts "the session class is #{@session.class}"
    req_cookie = req.cookies["_rails_lite_app"]
    @session_hash = req_cookie ? JSON.parse(req_cookie) : {}
  end

  def [](key)
    @session_hash[key]
  end

  def []=(key, val)
    @session_hash[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    session_cookie = @session_hash.to_json
    res.set_cookie("_rails_lite_app", {path: "/", value: session_cookie} )
  end
end
