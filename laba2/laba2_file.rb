require_relative 'T_cipher'
require_relative '../Block'

def raw oct
	oct.split('.').map{|x| x.to_i.to_s(2).rjust(8,"0")}.join
end

class ::String
	def nice
		self.split("").map.with_index {|x,i| (i%8==7 ? x<<" " : x)}.join
	end
end




puts "Input file path"
file_path = gets.chomp
input_file = File.open(file_path,'rb')
input = input_file.read
puts input
puts "Key(32 bit):"
key  = raw(gets.chomp)
puts key.nice



# Text => Blocks
blocks = Block.build(input, 2, fill: true)
puts "\nFirst block: #{blocks[0]}"
# Blocks => Encrypted blocks
encrypted_blocks = blocks.map do |x|
	T_cipher.encrypt(x,key)
end
puts "First encrypted block: #{encrypted_blocks[0]}"
# Encrypted blocks => Encrypted text
encrypted = encrypted_blocks.join
# Encrypted text => Transport code
to_transport = T_cipher.transport(encrypted, :encode)
puts "Transport text: #{to_transport}"



sent_message		 = to_transport.dup
recieved_message = sent_message.dup



# Transport code => Encrypted text
encrypted_text = T_cipher.transport(recieved_message, :decode)
# Encrypted text => Encrypted blocks
encrypted_blocks = Block.build(encrypted_text,2,fill: true)
puts "\nFirst encrypted block: #{encrypted_blocks[0]}"
# Encrypted blocks => Decrypted text blocks
decrypted_text_blocks = encrypted_blocks.map do |x|
	T_cipher.decrypt(x,key)
end
puts "First decrypted block: #{decrypted_text_blocks[0]}"
# Decrypted text blocks => Decrypted text
decrypted = decrypted_text_blocks.join
puts "Decrypted message: \n#{decrypted}"
