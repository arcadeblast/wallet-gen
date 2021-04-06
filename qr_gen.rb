module QRGen
  extend self

  def generate(val)
    RQRCode::QRCode.new(val)
  end

  def write(qr_code, destination)
    IO.binwrite(destination, qr_code.as_png.to_s)
  end

end
