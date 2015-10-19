require_relative 'Basics'
module T_cipher
	def self.f(block, key)
		Basics.ror(Basics.S(Basics.product(block,key),4),5)
	end

	def self.keygen(key,round,size)
    start = round*size%key.size
		key[start...start+size]
	end

  def self.zero x, x2, x3=0
    "00000000"
  end
end
