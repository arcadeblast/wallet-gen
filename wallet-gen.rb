require 'ecdsa'
require 'rqrcode'

require_relative 'private_key_gen'
require_relative 'public_key_gen'
require_relative 'public_address_gen'

DOGECOIN_MAIN_NET_PREFIX = '1e'

seed = nil
if ARGV[0]
  seed = Integer(ARGV[0])
else
  puts 'Warning: Relying on operating system to generate seed for private key. This may be unsecured.'
end

private_key = PrivateKeyGen.generate(seed)
public_key = PublicKeyGen.generate(private_key)
public_address = PublicAddressGen.generate(DOGECOIN_MAIN_NET_PREFIX, public_key)

puts 'Private Key:'
puts private_key
puts 'Public Address:'
puts public_address

qrcode = RQRCode::QRCode.new(public_address)
destination = "qr_public_address_#{public_address}.png"
IO.binwrite(destination, qrcode.as_png.to_s)

puts "Created public address QR code at #{destination}."