require 'Base64'
require_relative 'Basics'
module T_cipher
	def self.encrypt(plain, key)
		encrypted = F_crypt.encrypt(plain, key, 4, self.method(:f), self.method(:keygen))
		transport_encrypted = self.transport(encrypted, :encode)
		return [transport_encrypted, encrypted]
	end

	def self.decrypt(cipher, key)
		transport_decrypted = self.transport(cipher, :decode)
		decrypted = F_crypt.decrypt(cipher, key, 4, self.method(:f), self.method(:keygen))
		return [decrypted, transport_decrypted]
	end

	def self.f(block, key)
		puts "\tf( #{block} , #{key} ):"
		result = Basics.ror(Basics.S(Basics.product(block,key),4),5)
		puts "\t\t= #{result}"
		return result
	end

	def self.keygen(key,round,size)
		start = round*size%key.size
		return key[start...start+size]
	end

	def self.transport(msg, func=:encode)
		if func == :encode 
			Base64.encode64(msg)
		elsif func == :decode
			Base64.decode64(msg)
		end
	end

  def self.zero x, x2, x3=0
    "00000000"
  end
end
