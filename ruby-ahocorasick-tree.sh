
INPUTFILE="./keywords.txt"

File.open(INPUTFILE) do |file|
	file.each { |line|
		line.chomp!.split("").each{|c|
#			print "#{c} "	
		}
#		puts ""
	}	
end

class Trie
	def initialize
		@newindex = 0
		@trie = []
		@trie[0] = {} # root node
	end

	attr_accessor :index
	
	def construct(keywords)
		keywords.each{ |keyword|
			index, offset = self.find(keyword)

			p "find: #{keyword}, index: #{index}, offset:#{offset}"

			keyword[offset .. -1].split("").each{ |k|
				p "register #{k} in index(#{index})"
				index = register(index, k)	
			}
			@trie[index].store(:accept, true)
		}
	end

	def find(keyword)
		index = 0
		offset = 0
		keyword.split("").each{|k|
			if @trie[index].key?(k)	
				index = @trie[index][k]
				offset = offset + 1
			else 
				return [index, offset]	
			end
		}
		return [index, offset]
	end
	
	def register(index, k)
		@newindex = @newindex + 1
		@trie[@newindex] =  {parent: index}
		@trie[index].store(k, @newindex)
		@newindex
	end

	def printWord()
		_printWord("",0)
	end

	def _printWord(str, index)
		node = @trie[index].dup
#		node.delete(:parent); node.delete(:fail); node.delete(:accept)
		puts (str) if node.key?(:accept)
		node.each {|k,i|
			if(k == :fail || k == :parent || k == :accept)
				#do nothing
			else
				_printWord(str + k, i)		
			end
		}	
	end
end

keywords = File.open(INPUTFILE, :encoding => Encoding::UTF_8).collect(&:chomp)

trie = Trie.new
#trie.construct(["aaa","aa","ccc","ddd", "aab", "bbbc"])
trie.construct(keywords)
trie.printWord
