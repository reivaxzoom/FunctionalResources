 module Main where

--catalan :: Float -> Float 
--catalan n = factorial n/ (factorial n+1 * factorial n)
-- Expresion:   (2n)!/((n+1)!*n!)
--catalan n = product [x | x <-[1..2*n] ] / (product[n+1,n..1]*product[n,n-1..1]

--Expresion: 2(5)! / (5+1)!*(5!) = 42 
-- product[1..10]/(product[1..6] * product[1..5])



factorial :: Integer -> Integer 
factorial n = product [1..n]

--Check if a number is perfect
perfect :: Integer -> Bool
perfect p = if (p == (sum(divisors p) `div` 2)) 
            then True 
            else False




--calculate infinite the list of perfect numbers
perfectList :: () -> [Integer]
perfectList p = [x| x <- [2..], sum(divisors x) `div` 2 == x  ]


     -- Print all upercase letter in a 
rmoNoUc :: [Char] -> [Char] 
rmoNoUc st = [ c | c <- st, c `elem` ['\[']] 



--retrieves the list of divisors
divisors :: Integer -> [Integer]
divisors n =[1]++[ x | x <- [2..(n`div`2)], n `rem` x== 0]++[n]


-- Print all upercase letter in a 
-- rmoNoUc :: [Char] -> [Char] 
-- rmoNoUc st = [ c | c <- st, c `elem` ['A'..'Z']] 

isUserNameValid :: String -> Bool
isUserNameValid "" = False        -- blank user name is wrong
isUserNameValid "root" = False    -- reserved user name is wrong
isUserNameValid _ = True

--null :: [a] -> Bool
--null [] = True
--null _  = False
--head :: [a] -> a
--head (x:xs) = x
--tail :: [a] -> [a]
--tail (x:xs) = xs


repeatq :: a -> [a]
repeatq x = x : repeat x

--takeq :: Int -> [a] -> [a]
--takeq 0 _ = []
--takeq n [] = []
--takeq _ _  = []
--takeq n (x:xs) |n > 0 = x: take (n-1) xs
--takeq 3 [1,2,3,4,5,6]



--take with guards
take :: Int -> [a] -> [a]
take _ [] = []
take n (x:xs)
| n> 0  =x : (take (n-1) xs)
|otherwise =[]




--filter :: (a -> Bool) -> [a] -> [a]
--filter p[] = []
--filter (x:xs)
--   | p x = x: filter p xs
--   | not (p x) = filter p xs



--import Data.List
--insert 6  [1,3..10]


