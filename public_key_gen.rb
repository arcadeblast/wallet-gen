module PublicKeyGen
  extend self

  def generate(private_key)
    group = ECDSA::Group::Secp256k1
    point = group.generator.multiply_by_scalar(private_key.to_i(16))
    ECDSA::Format::PointOctetString.encode(point, compression: true).unpack('H*').first
  end

end