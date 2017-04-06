list = [1, 2, 3, 4, 5]
 
main = do
    print list
 
    print $ head list
    print $ tail list
    print $ last list
    print $ init list
 
    print $ list !! 3
    print $ elem 3 list
 
    print $ length list
    print $ null list
    print $ reverse list
 
    print $ take 2 list
    print $ drop 2 list
 
    print $ minimum list
    print $ maximum list
 
    print $ sum list
    print $ product list
 
    print [1..10]
    print ['A'..'Z']
    

--Iterate over a list
it :: [Int] -> Int
it [] = 0 
it n = head(n) + it(tail(n))

--other iteration way
f2 :: [Int] -> Int
f2 [] = 0 
f2 (x:xs) = x + f2(xs)

    
        --let boomBangs xs = [ if x < 10 then "BOOM!" else "BANG!" | x <- xs, odd x]
     -- boomBangs [1..13]

     -- Print all upercase letter in a 
rmoNoUc :: [Char] -> [Char] 
rmoNoUc st = [ c | c <- st, c `elem` ['A'..'Z']] 
    
    
    
upperLower :: Char -> Char
upperLower c 
 | isLower c = toUpper c
 | isUpper c = c
 |otherwise = c
    
    
splitAt _[] = ([],[])
splitAt n (x:xs)
 |n>0 =(x:ys1,ys2)
 |otherwise = ([[]], x:xs)
where
 (ys1,ys2) =splitAt (n-1) xs
 
 
 twice f x = f (f x)
     
    
    
    count :: (a -> Bool) -> [a] -> Int
    count p xs = sum [1 | x <- xs , p x]