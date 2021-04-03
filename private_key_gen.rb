module PrivateKeyGen
  extend self

  PRIVATE_KEY_MAX = 115792089237316195423570985008687907852837564279074904382605163141518161494336

  def generate(seed = nil)
    # If a seed is not provided, the operating system is relied on to generate one. This may be unsecured.
    seed = Random.new_seed unless seed
    r = Random.new(seed)
    r.rand(PRIVATE_KEY_MAX).to_s(16)
  end

end
