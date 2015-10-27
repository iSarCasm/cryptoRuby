require_relative 'T_cipher'
require_relative 'F_crypt'

def raw oct
	oct.split('.').map{|x| x.to_i.to_s(2).rjust(8,"0")}.join
end

class ::String
	def nice
		self.split("").map.with_index {|x,i| (i%8==7 ? x<<" " : x)}.join
	end
end

puts "Input(16 bit):"
input = raw(gets.chomp)
puts input.nice
puts "Key(32 bit):"
key  = raw(gets.chomp)
puts key.nice

encrypted_transport, encrypted = T_cipher.encrypt(input,key)
#SENDER
message = encrypted.dup
#RECIEVER
decrypted, transport_decrypted = T_cipher.decrypt(message, key)

puts "Encrypted:"
puts encrypted.nice
puts "Transport code:"
puts encrypted_transport
puts "Decoded transport:"
puts transport_decrypted
puts "Decrypted:"
puts decrypted.nice
puts "Result: \n\t#{input.nice} \n\t== \n\t#{decrypted.nice}"
