require 'ecdsa'

MAX = 115792089237316195423570985008687907852837564279074904382605163141518161494336
HEX = 16

def gen_private_key(seed)
  seed = seed || Random.new_seed
  r = Random.new(seed.to_i)
  r.rand(MAX).to_s(HEX)
end

def hash160(hex)
  bytes = [hex].pack("H*")
  Digest::RMD160.hexdigest Digest::SHA256.digest(bytes)
end

def hash160_to_address(hex)
  encode_address hex, '1e'
end

def encode_address(hex, version)
  address_byte_string = version + hex + checksum(hex)
  base58_check(address_byte_string.to_i(16))
end

def checksum(hex)
  b = [hex].pack("H*") # unpack hex
  Digest::SHA256.hexdigest( Digest::SHA256.digest(b) )[0...8]
end

def base58_check(address_byte_string)
  alpha = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
  base58_val = ''
  while address_byte_string > 0
    address_byte_string, remainder = address_byte_string.divmod(58)
    base58_val = alpha[remainder] + base58_val
  end
  base58_val
end

private_key = gen_private_key(ARGV[0])

group = ECDSA::Group::Secp256k1
point = group.generator.multiply_by_scalar(private_key.to_i(HEX))
public_key = ECDSA::Format::PointOctetString.encode(point, compression: true).unpack('H*').first

puts 'Private Key:'
puts private_key
puts 'Public Key:'
puts public_key
puts 'Public Address:'
puts hash160_to_address(hash160(public_key))
