require 'ecdsa'

SEED = ARGV[0] || Random.new_seed
MAX = 115792089237316195423570985008687907852837564279074904382605163141518161494336
HEX = 16
gen = Random.new(SEED.to_i)

private_key_base10 = gen.rand(MAX)

group = ECDSA::Group::Secp256k1
point = group.generator.multiply_by_scalar(private_key_base10)
public_key_base16 = ECDSA::Format::PointOctetString.encode(point, compression: true).unpack('H*').first

puts 'Private Key:'
puts private_key_base10.to_s(HEX)
puts 'Public Key:'
puts public_key_base16