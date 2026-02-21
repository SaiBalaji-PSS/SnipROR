class JwtHandler
  SECRET_KEY = "KUDOSHINICHI"
  def self.encode_jwt_token(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    encoded_token = JWT.encode(payload, SECRET_KEY)
    encoded_token
  end


  def self.decode_jwt_token(token)
    decoded_token = JWT.decode(token, SECRET_KEY)
    payload_from_token = decoded_token[0] # Take payload part alone
    HashWithIndifferentAccess.new(payload_from_token)
  end
end
