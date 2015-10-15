require_relative '../Block'
require_relative '../P_crypt'
require_relative '../S_crypt'

describe P_crypt do
	it "Has encryption" do
		expect(P_crypt.respond_to?('encrypt')).to eq(true)
	end

	it "Has decryption" do
		expect(P_crypt.respond_to?('decrypt')).to eq(true)
	end

	it "has neutral keys" do
		input = "12345678 typical input string\n \k3k"
		expect(P_crypt.encrypt(input,"01234567")[0...input.size]).to eq(input)
		expect(P_crypt.encrypt(input,"0123")[0...input.size]).to eq(input)
		expect(P_crypt.encrypt(input,"0123456789")[0...input.size]).to eq(input)
		expect(P_crypt.encrypt(input,"0")[0...input.size]).to eq(input)
		expect(P_crypt.encrypt(input,[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16])[0...input.size]).to eq(input)
		expect(P_crypt.encrypt(input,"123",from_one: true)[0...input.size]).to eq(input)
	end

	it "has proper permutations" do
		# Test 1
		input = "12345678"
		expect(P_crypt.encrypt(input,"10")[0...input.size]).to eq("21436587")
		expect(P_crypt.encrypt(input,[1,0])[0...input.size]).to eq("21436587")
		# Test 2
		input = "Som2 TeXT#{13.chr}-\nk3k"
		key = "312"
		expect(P_crypt.encrypt(input,key,from_one:true)[0...input.size]).to eq("mSoT2 TeX\n#{13.chr}-kk3")
	end
end

describe S_crypt do
	it "Has encryption" do
		expect(S_crypt.respond_to?('encrypt')).to eq(true)
	end

	it "Has decryption" do
		expect(S_crypt.respond_to?('decrypt')).to eq(true)
	end

	it "has neutral keys" do
		input = "12345678 typical input strings"
		expect(S_crypt.encrypt(input,"0")).to eq(input)
		expect(S_crypt.encrypt(input,0)).to eq(input)
		expect(S_crypt.encrypt(input,[0,0,0])).to eq(input)
	end

	it "has proper Ceazar substitution" do
		input = [13,44,77,44,55,66,34,87,43,113,222,131,221,10].map{|x| x.chr}.join
		output = [13,47,80,47,58,69,37,90,46,116,225,134,224,10].map{|x| x.chr}.join
		expect(S_crypt.encrypt(input,"3")).to eq(output)
		expect(S_crypt.encrypt(input,3)).to eq(output)
		expect(S_crypt.encrypt(input,"333")).to eq(output)
	end

	it "has proper Lagrange substitution" do
		input = [13,44,77,44,55,66,34,87,43,113,222,131,221,10].map{|x| x.chr}.join
		output = [13,46,78,47,57,67,37,89,44,116,224,132,224,10].map{|x| x.chr}.join
		expect(S_crypt.encrypt(input,"321")).to eq(output)
		expect(S_crypt.encrypt(input,[3,2,1])).to eq(output)
	end

	it "accepts string keys" do
		input = [13,44,77,44,55,66,34,87,43,113,222,131,221,10].map{|x| x.chr}.join
		output = [13,46,78,47,57,67,37,89,44,116,224,132,224,10].map{|x| x.chr}.join
		key = [3,2,1].map{|x| x.chr}.join
		expect(S_crypt.encrypt(input,key,string_key: true)).to eq(output)
	end

end
