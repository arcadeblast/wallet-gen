module PublicAddressGen
  extend self

  def generate(net_prefix, public_key)
    address_byte_string = ''
    address_byte_string += net_prefix
    address_byte_string += hash160(public_key)
    address_byte_string += checksum(address_byte_string)
    base58_check(address_byte_string)
  end

  private

  def hash160(hex)
    bytes = [hex].pack("H*")
    Digest::RMD160.hexdigest(Digest::SHA256.digest(bytes))
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

end
