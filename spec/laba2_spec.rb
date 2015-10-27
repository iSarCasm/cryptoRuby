require_relative '../F_crypt'
require_relative '../Basics'
require_relative '../T_cipher'

describe Basics do
	it "XOR works" do
		expect(Basics.XOR("10101","11101")).to eq("01000")
		expect(Basics.XOR("01","01")).to eq("00")
		expect(Basics.XOR("1111","1100")).to eq("0011")
		expect(Basics.XOR("1001","0000")).to eq("1001")
		expect(Basics.XOR("111","111")).to eq("000")
		expect(Basics.XOR(Basics.XOR("1011","1100"),"1100")).to eq("1011")
	end

	it "ROR works" do
		expect(Basics.ror("1111",5)).to eq("1111")
		expect(Basics.ror("0001",5)).to eq("1000")
		expect(Basics.ror("1010",1)).to eq("0101")
		expect(Basics.ror("1110",3)).to eq("1101")
		expect(Basics.ror("0100",0)).to eq("0100")
		expect(Basics.ror("0010",4)).to eq("0010")
		expect(Basics.ror("11111111101",1)).to eq("11111111110")
		expect(Basics.ror("111000",3)).to eq("000111")
		expect(Basics.ror("1",5)).to eq("1")
	end

	it "Product works" do
		expect(Basics.product("1","111")).to eq("111")
		expect(Basics.product("0","111")).to eq("000")
		expect(Basics.product("111","1000")).to eq("1000")
	end

	it "S works" do
		expect(Basics.S("11110000",4)).to eq("01100101")
		expect(Basics.S("00111100",4)).to eq("10010011")
		expect(Basics.S("11000011",4)).to eq("11011001")
	end
end

describe T_cipher do
	it "Keygen works" do
		key = "01101001111111110000110111111111"
		expect(T_cipher.keygen(key,0,8)).to eq("01101001")
		expect(T_cipher.keygen(key,1,8)).to eq("11111111")
		expect(T_cipher.keygen(key,2,8)).to eq("00001101")
		expect(T_cipher.keygen(key,3,8)).to eq("11111111")
		#
		expect(T_cipher.keygen(key,4,8)).to eq("01101001")
		expect(T_cipher.keygen(key,5,8)).to eq("11111111")
	end

	it "Transport coding works" do
		source = "01101001111111110000110111111111"
		encrypted = T_cipher.transport(source,:encode)
		decrypted = T_cipher.transport(encrypted, :decode)
		expect(decrypted).to eq(source)
	end

	it "T_cipher Encryption-Decryption works" do
		input = "1100101101110010"
		key = 	"01110101110011010000001000100110"
		encrypted_transport, encrypted = T_cipher.encrypt(input,key)
		message = encrypted.dup
		decrypted, transport_decrypted = T_cipher.decrypt(message, key)
		expect(decrypted).to eq(input)
	end
end

describe F_crypt do
	it "Swaps blocks" do
		expect(F_crypt.encrypt("0000000011111111",nil,0,T_cipher.method(:zero), T_cipher.method(:zero))).to eq("1111111100000000")
		expect(F_crypt.decrypt("0000000011111111",nil,0,T_cipher.method(:zero), T_cipher.method(:zero))).to eq("1111111100000000")

		expect(F_crypt.encrypt("0000000011111111",nil,1,T_cipher.method(:zero), T_cipher.method(:zero))).to eq("0000000011111111")
		expect(F_crypt.decrypt("0000000011111111",nil,1,T_cipher.method(:zero), T_cipher.method(:zero))).to eq("0000000011111111")

		expect(F_crypt.encrypt("0000000011111111",nil,2,T_cipher.method(:zero), T_cipher.method(:zero))).to eq("1111111100000000")
		expect(F_crypt.decrypt("0000000011111111",nil,2,T_cipher.method(:zero), T_cipher.method(:zero))).to eq("1111111100000000")
	end

	it "F_crypt system works" do
		input = "1100101101110010"
		key = 	"01110101110011010000001000100110"
		encrypted = F_crypt.encrypt(input, key, 1, T_cipher.method(:f), T_cipher.method(:keygen))
		expect(F_crypt.decrypt(encrypted, key, 1, T_cipher.method(:f),T_cipher.method(:keygen))).to eq(input)


		input = "0000000000000001"
		key = 	"00000000000000000000000000000000"
		encrypted = F_crypt.encrypt(input, key, 1, T_cipher.method(:f), T_cipher.method(:keygen))
		expect(F_crypt.decrypt(encrypted, key, 1, T_cipher.method(:f),T_cipher.method(:keygen))).to eq(input)
	

		input = "1001100011100101"
		key = 	"1110011000010000100011100000101"
		encrypted = F_crypt.encrypt(input, key, 1, T_cipher.method(:f), T_cipher.method(:keygen))
		expect(F_crypt.decrypt(encrypted, key, 1, T_cipher.method(:f),T_cipher.method(:keygen))).to eq(input)
	end
end
