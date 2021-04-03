require 'ecdsa'
require 'rqrcode'

require_relative 'private_key_gen'
require_relative 'public_key_gen'

DOGECOIN_MAIN_NET_PREFIX = '1e'

def hash160(hex)
  bytes = [hex].pack("H*")
  Digest::RMD160.hexdigest(Digest::SHA256.digest(bytes))
end

def public_key_to_address(net_prefix, public_key)
  address_byte_string = ''
  address_byte_string += net_prefix
  address_byte_string += hash160(public_key)
  address_byte_string += checksum(address_byte_string)
  base58_check(address_byte_string)
end

def checksum(hex)
  b = [hex].pack("H*") # unpack hex
  Digest::SHA256.hexdigest( Digest::SHA256.digest(b) )[0...8]
end

def base58_check(address_byte_string)
  addr_base10 = address_byte_string.to_i(16)
  alpha = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
  result = ''
  while addr_base10 > 0
    addr_base10, remainder = addr_base10.divmod(58)
    result = alpha[remainder] + result
  end
  result
end

seed = nil
if ARGV[0]
  seed = Integer(ARGV[0])
else
  puts 'Warning: Relying on operating system to generate seed for private key. This may be unsecured.'
end
private_key = PrivateKeyGen.generate(seed)

public_key = PublicKeyGen.generate(private_key)

public_address = public_key_to_address(DOGECOIN_MAIN_NET_PREFIX, public_key)#public_key_to_address(DOGECOIN_MAIN_NET_PREFIX, public_key)

puts 'Private Key:'
puts private_key
puts 'Public Address:'
puts public_address

qrcode = RQRCode::QRCode.new(public_address)

IO.binwrite("qr_public_address_#{public_address}.png", qrcode.as_png.to_s)
