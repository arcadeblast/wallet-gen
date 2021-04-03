module PrivateKeyGen
  extend self

  def generate(seed)
    unless seed
      seed = Random.new_seed
      puts 'Warning: Using non-secure seed to generate private key.'
    end
    r = Random.new(seed.to_i)
    r.rand(PRIVATE_KEY_MAX).to_s(16)
  end

end
