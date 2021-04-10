module Compositer
  extend self

  def composite(path_to_first_image:, path_to_second_image:, x:, y:, resize:, rotate:, destination:)
    first_image = MiniMagick::Image.open path_to_first_image
    second_image = MiniMagick::Image.open path_to_second_image
    second_image.gravity 'center'
    second_image.resize("#{resize}x#{resize}")
    second_image.rotate("#{rotate}")
    result = first_image.composite(second_image) do |c|
      c.compose "Over"
      c.geometry "+#{x}+#{y}"
    end
    result.write destination
  end
end
