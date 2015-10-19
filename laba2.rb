require_relative 'T_cipher'
require_relative 'F_crypt'

def raw oct
	oct.split('.').map{|x| x.to_i.to_s(2).rjust(8,"0")}.join
end


puts "Input(16 bit):"
input = raw(gets.chomp)
puts input
puts "Key(32 bit):"
key  = raw(gets.chomp)
puts key

encrypted = F_crypt.encrypt(input, key, 4, T_cipher.method(:f), T_cipher.method(:keygen))
decrypted = F_crypt.decrypt(encrypted, key, 4, T_cipher.method(:f), T_cipher.method(:keygen))

puts "Encrypted:"
puts encrypted
puts "Decrypted:"
puts decrypted
puts "Result: #{input} == #{decrypted}"
