require 'base64'
require_relative 'Basics'
require_relative 'F_crypt'

module T_cipher
	def self.encrypt(plain, key, debug: false)
		plain_binary = to_binary(plain)
		encrypted_binary = F_crypt.encrypt(plain_binary, key, 4, self.method(:f), self.method(:keygen), debug)
		to_char(encrypted_binary)
	end

	def self.decrypt(cipher, key, debug: false)
		cipher_binary = to_binary(cipher)
		decrypted_binary = F_crypt.decrypt(cipher_binary, key, 4, self.method(:f), self.method(:keygen), debug)
		to_char(decrypted_binary)
	end

	def self.f(block, key, debug=false)
		puts "\tf( #{block} , #{key} ):" if debug
		Basics.debug = debug
		result = Basics.ror(Basics.S(Basics.product(block,key),4),5)
		puts "\t\t= #{result}" if debug
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

	private
		def self.to_binary (text)
			text.split("").map{|x| x.ord.to_s(2).rjust(8,"0")}.join
		end
		def self.to_char (bin)
			bin[0..7].to_i(2).chr << bin[8..15].to_i(2).chr
		end


  def self.zero x, x2, x3=0
    "00000000"
  end

end
