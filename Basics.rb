
module Basics

  TABLE1 = [14, 0, 15, 9, 2, 1, 10, 12, 8, 3, 11, 4, 13, 5, 7, 6].map{ |x| x.to_s(2).rjust(4,"0") }
  TABLE2 = [5, 1, 8, 9, 10, 2, 11, 12, 13, 4, 7, 6, 3, 14, 0, 15].map{ |x| x.to_s(2).rjust(4,"0") }
  # puts "table1 = #{TABLE1}"
  # puts "table2 = #{TABLE2}"
  def self.ror block, n
    block_s = block.dup
    n = n % block.size
    block = block.split("")
  	deleted = block.pop(n)
    result  = deleted + block
    result = result.join
    puts "\t\t#{block_s}>>(#{n}) = #{result}"
    return result
  end

  def self.product a, b
    size = (a.size > b.size ? a.size : b.size)
  	r = (a.to_i(2) * b.to_i(2))
    r = (r % (2**size).to_i).to_s(2).rjust(size,"0")
    puts "\t\t#{a} * #{b} = #{r}"
    return r
  end

  def self.S block, size
    # puts "size: #{size}"
    # puts "\t1: #{block[0...size]}"
    # puts "\t2: #{block[size...size*2]}"
    half1 = block[0...size]
    half2 = block[size...size*2]
  	a = TABLE1[half1.to_i(2)].dup
    b = TABLE2[half2.to_i(2)].dup
    r = a + b
    puts "\t\t[#{half1}][#{half2}] -> [#{a}][#{b}]"
    return r
  end

  def self.XOR(string1, string2)
    s1 = string1.split("").map{|x| x == "1"}
    s2 = string2.split("").map{|x| x == "1"}
    for x in 0...s1.size
      s1[x] = s1[x]^s2[x]
    end 
    s1 = s1.map{|x| (x ? "1" : "0")}.join("")
    puts "\tXOR(#{string1}, #{string2}) = #{s1}"
    return s1
  end
end
