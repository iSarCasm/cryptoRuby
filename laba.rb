require_relative 'Block'
require_relative 'Gamma'
require_relative 'P_crypt'
require_relative 'S_crypt'
#======DATA=====================================================
args = {}
encryptionMethod = P_crypt
args[:input_type] = 'console'
args[:key_data_type] = "str"
args[:key_type] = 'console'
args[:output_console] = true
args[:from_one] = false;
for i in 0...ARGV.size do
	a = ARGV[i]
	c = ARGV[i][0..1]
	n = ARGV[i][2..-1]
	if c ==	'-m'
		encryptionMethod = P_crypt if n.include?('p')
		encryptionMethod = S_crypt if n.include?('s')
		# puts encryptionMethod
	elsif c == '-i'
		args[:input_type] = 'file' 			if n.include?('f')
		args[:input_type] = 'console' 	if n.include?('c')
	elsif c == '-k'
		args[:key_type] = 'file' 			if n.include?('f')
		args[:key_type] = 'console' 	if n.include?('c')
		args[:key_type] = 'gamma' 		if n.include?('g')
	elsif c == '-o'
		args[:output_console] = 	n.include?('c')
		args[:output_file] = 			n.include?('f')
	elsif a == 'one'
		args[:from_one] = true;
	elsif a == 'int'
		args[:key_data_type] = "int"
	elsif a == 'str'
		args[:string_key] = true
	end
end
puts "#{args}"
ARGV.clear
#--------------------------------
if args[:input_type] == 'file' then
 	fi = File.open("i.txt",'rb')
	input = fi.read
end
#--------------------------------
if args[:input_type] == 'console' then
 	puts "Input data: "
	input = gets.chomp
end
#--------------------------------
#----------------------------------------------------------------
if args[:key_type] == 'console' || args[:key_type] == 'gamma' then
 	puts "Input key: "
	key = gets.chomp
end
#--------------------------------
if args[:key_type] == 'file'
 	fk = File.open("k.txt",'rb')
	key = fk.read
	args[:string_key] = true
end
#--------------------------------
if args[:key_type] == 'gamma' then
	args[:string_key] = true
end
if args[:key_data_type] == "int"
	key = key.split.map{|x| x.to_i}
end
#================================================================
#set keys
encrypt_key, decrypt_key = key.dup, key.dup

encrypt_key = Gamma.gamma(key,input.size) if args[:key_type] == 'gamma' #Gamma message-size key
encrypted = encryptionMethod.encrypt(input, encrypt_key, from_one: args[:from_one], string_key: args[:string_key])

decrypt_key = Gamma.gamma(key,encrypted.size) if args[:key_type] == 'gamma' #Gamma message-size key
decrypted = encryptionMethod.decrypt(encrypted, decrypt_key, from_one: args[:from_one], string_key: args[:string_key])
# ======OUTPUT=====================================================
if args[:output_console]
	puts "Key: \n#{key}\n" if args[:key_type] == 'file'
	puts "Got as an input------------------------------
#{input}
------size:#{input.size}---------------------------------------"
	puts "ENCRYPTED ------------------------------------ \n#{encrypted}\n"
	puts "with key: #{encrypt_key} \n" if args[:key_type] == 'gamma'
	puts "------size: #{encrypted.size}---------------------------------------"
	puts "DECRYPTED ------------------------------------ \n#{decrypted}\n"
	puts "with key: #{decrypt_key} \n" if args[:key_type] == 'gamma'
	puts "------size: #{decrypted.size}---------------------------------------"
end
#--------------------------------
if args[:output_file]
	File.open('e.txt', 'wb') do |file|
	  file.write(encrypted)
	end
	#--------------------------------
	File.open('d.txt', 'wb') do |file|
	  file.write(decrypted)
	end
end
#================================================================
