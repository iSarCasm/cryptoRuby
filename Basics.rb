
module Basics

  TABLE1 = [14, 0, 15, 9, 2, 1, 10, 12, 8, 3, 11, 4, 13, 5, 7, 6].map{ |x| x.to_s(2).rjust(4,"0") }
  TABLE2 = [5, 1, 8, 9, 10, 2, 11, 12, 13, 4, 7, 6, 3, 14, 0, 15].map{ |x| x.to_s(2).rjust(4,"0") }

  def self.ror block, n
    n = n % block.size
    block = block.split("")
  	deleted = block.pop(n)
    result  = deleted + block
    result.join
  end

  def self.product a, b, mod = 0
  	r = (a.to_i(2) * b.to_i(2))
    (mod == 0 ? r : r % mod).to_s(2)
  end

  def self.S block, size
  	a = TABLE1[block[0...size].to_i(2)]
    b = TABLE2[block[size...size*2].to_i(2)]
    a << b
  end

  def self.XOR(string1, string2)
    s1 = string1.split("").map{|x| x == "1"}
    s2 = string2.split("").map{|x| x == "1"}
    for x in 0...s1.size
      s1[x] = s1[x]^s2[x]
    end
    s1.map{|x| (x ? "1" : "0")}.join("")
  end
end
