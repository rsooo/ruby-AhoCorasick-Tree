
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
		@trie[0] = {parent: 0, fail: 0} # root node
	end

	attr_accessor :index
	
	def construct(keywords)
		keywords.each{ |keyword|
			index, offset = self.find(keyword)

#			p "find: #{keyword}, index: #{index}, offset:#{offset}"

			keyword[offset .. -1].split("").each{ |k|
#				p "register #{k} in index(#{index})"
				index = register(index, k)	
			}
			@trie[index].store(:accept, keyword)
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

		@trie.each_with_index{|node, idx|
			p "index:#{idx} #{node}"	
		}
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

	def createFail
		queue = Queue.new
		queue.push(["", 0])

		while !queue.empty?
			k,index = queue.pop
			@trie[index].each{|k,i|
				if(k == :fail || k == :parent || k == :accept)
					#do nothing
				else
					queue.push([k,i])	
				end
			}
			
			pindex = @trie[index][:parent]
			if pindex == 0
				@trie[index][:fail] = 0
			else
				findex = @trie[pindex][:fail]
				if @trie[findex][k] == nil
					@trie[index][:fail] = 0
				else
					@trie[index][:fail] = @trie[findex][k]
					p "createfail #{k} #{index} to #{@trie[findex][k]}"
				end
			end
		end

#		@trie[index].each{|k,i|
#			if(k == :fail || k == :parent || k == :accept)
#				#do nothing
#			else
#				createFail(i)
#			end
#		}
	end

	def g(index, input)
		nextIndex = @trie[index][input]
		findex = index
#		p nextIndex
		while(nextIndex == nil)
			findex = @trie[findex][:fail]
			nextIndex = @trie[findex][input]
#			p "#{nextIndex} + #{findex}"
			return [0, nil] if findex == 0 && nextIndex == nil
		end
		[nextIndex, @trie[nextIndex][:accept]]
	end

	def match(text)
		index = 0
		text.split("").each_with_index{|t,textIdx|
#			p "g(#{index}, #{t})"
			index, accept = g(index, t)	
#			p "index: #{index}, accept: #{accept}"	
			if accept != nil
				puts "find: #{accept}, offset #{textIdx - accept.length + 1} to #{textIdx}"
			end
#			puts ""
		}
	end
end

keywords = File.open(INPUTFILE, :encoding => Encoding::UTF_8).collect(&:chomp)

trie = Trie.new
trie.construct(["ab","bc","bab","d", "abcde" ])
#trie.construct(keywords)
trie.createFail
trie.printWord

#text= "xbabcdex"
text= "xababdddbbbbbcxxx"
trie.match(text)

