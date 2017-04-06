module ComplexAssigment where 

import Data.Char
import Data.Bits
import Data.List

--aditive hash 
additiveHash :: Int -> [Int] -> Int 
additiveHash x y = sum y `rem` x

--pearson hash
pearsonHash :: [Int] -> [Int] -> Int
pearsonHash t c =f c 0
  where 
    f [] h = h
    f (c:cs) h = f cs (t !! index)
        where
            index = h `xor` c

--Deriving keys
keys :: [Int] -> [Int]
keys x = [additiveHash 191 x, pearsonHash [255, 254 .. 0] x] 

--Setting a bit in the bit array
set :: Ord a => a -> [a] -> [a]
set x [] = [x]
set x (y:ys)
    | x > y     = y : set x ys
    | x== y     = y: ys
    | otherwise = x : y : ys

--Empty Bloom filter
type BloomFilter = [Int]
empty :: BloomFilter
empty=[]

--Extending the Bloom filter
add :: BloomFilter -> [Int] -> BloomFilter
add []  [] =  [0]
add [] y = keys y
add  (x:xs)  y =  set x (add xs  y)

--Testing with the Bloom filter
has :: BloomFilter -> [Int] -> Bool 
has b x= (keys x\\b == []) 

--Translating strings
translate :: String -> [Int]
translate s = [ ord (toUpper c) |  c <- s, isAlpha c] 

--Building a Bloom filter from a set of strings
wordFilter :: [String] -> BloomFilter
wordFilter []          = add empty []
wordFilter (w:[]) = add empty (translate w) 
wordFilter (w:ws) = add  (wordFilter(ws)) (translate w)

--Implementing a spellchecker with a Bloom filter
spellCheck :: BloomFilter -> String -> [Int]
spellCheck b s = [a | (a,c)<- [x |x<-zip [0..] (map (translate)(words s))], not(has (b) c) ] 
 

main= do
print("TestCases")
print("Additive hashing")
print(additiveHash 191 [1..10] ==  55) 
print(additiveHash 211 [ ord c | c <- "Hello" ] ==  78) 

print("Pearson hashing")
print(pearsonHash ([0..127] ++ [255,254..128]) [1..10] ==  11 )
print(pearsonHash [255,254..0] [ ord c | c <- "Hello" ] ==  189)

print("Deriving keys")
print(keys [1..100] ==  [84,100])
print(keys [ ord c | c <- "Hello" ] ==  [118,189])

print("Empty Bloom filter")
print(empty == [])

print("Setting a bit in the bit array")
print(set 0 [1,3,5]  ==  [0,1,3,5])
print(set 2 [1,3,5]  ==  [1,2,3,5])
print(set 5 [1,3,5]  ==  [1,3,5])
print(set 9 [1,3,5]  ==  [1,3,5,9])

print("Extending the Bloom filter")
print(empty `add` [] ==  [0])
print(empty `add` [1..5]  ==  [15,254])
print((empty `add` [4,2,8]) `add` [9,0,7]  ==  [14,16,241])

print("Testing with the Bloom filter")
print(not( empty `has` [1..10]))
print((empty `add` [1..10]) `has` [1..10])
print(((empty `add` [2,5..10]) `add` [13,15..20]) `has` [2,5..10])

print("Translating strings")
print(translate "42"           ==  []) 
print(translate "!!!"          ==  [])
print(translate "M'Okay?"      ==  [77,79,75,65,89])
print(translate "1984winston"  ==  [87,73,78,83,84,79,78])


print("Building a Bloom filter from a set of strings")
print((wordFilter ["foo", "bar", "baz"]) `has` (translate "foo"))
print((wordFilter ["foo", "bar", "baz"]) `has` (translate "baz"))
print(not ((wordFilter ["foo", "bar", "baz"]) `has` (translate "foobar")))

print("Implementing a spellchecker with a Bloom filter")
print(spellCheck (wordFilter ["a","is","this","sentence","wrong"]) "Is this a wrong sentence?"  ==  [])
print(spellCheck (wordFilter ["one","two","three"]) "One, tu, three!"  ==  [1])
print(spellCheck (wordFilter ["pomme","table"]) "Il y a une pomme sur la table."  ==  [0,1,2,3,5,6])



