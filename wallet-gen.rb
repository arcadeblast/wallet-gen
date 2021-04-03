require 'ecdsa'
require 'rqrcode'

require_relative 'private_key_gen'

PRIVATE_KEY_MAX = 115792089237316195423570985008687907852837564279074904382605163141518161494336
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

private_key = PrivateKeyGen.generate(ARGV[0])

group = ECDSA::Group::Secp256k1
point = group.generator.multiply_by_scalar(private_key.to_i(16))
public_key = ECDSA::Format::PointOctetString.encode(point, compression: true).unpack('H*').first

public_address = public_key_to_address(DOGECOIN_MAIN_NET_PREFIX, public_key)#public_key_to_address(DOGECOIN_MAIN_NET_PREFIX, public_key)

puts 'Private Key:'
puts private_key
puts 'Public Address:'
puts public_address

qrcode = RQRCode::QRCode.new(public_address)

IO.binwrite("public_address.png", qrcode.as_png.to_s)