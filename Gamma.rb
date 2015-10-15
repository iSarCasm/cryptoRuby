class Gamma
  def self.gamma(key, size, options={})
    gamma_key = String.new
    gamma_rand = Random.new(generateSeed(key)) #pseudo-rand based on key
  	for x in 0...size do
  		gamma_key += gamma_rand.rand(32..255).chr;
  	end
    return gamma_key
  end

  private
    def self.generateSeed(key)
      if key.class.to_s == "String" then
        seed = key.split("").collect{ |k| k.ord }.inject {|sum, k| sum += k}
      end
      return seed
    end
end
