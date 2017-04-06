module Data where


data SearchTree a = E | T a (SearchTree a) (SearchTree a)  deriving(Show, Eq, Ord)

empty :: SearchTree a
empty = E


toList :: SearchTree a -> [a]
toList E = []
toList (T a E E) = [a]
toList (T a b c) = [a]++ toList b ++toList c


insert :: Ord a => a -> SearchTree a -> SearchTree a
insert x E = T x E E
insert x (T y a b)
 | x == y = T y a b
 | x < y  = T y b (insert x a ) 
 | x > y  = T y   (insert x b ) a


fromList :: Ord a => [a] -> SearchTree a
fromList [] = empty
fromList (x:xs) = fromList2 xs (T x E E) 
        where 
            fromList2 [] tr = tr    
            fromList2 (y:ys) tr= fromList2 ys (insert x tr)     


contains :: Ord a => SearchTree a -> a -> Bool
contains E _  = False
contains (T x a b) y
        | x == y = True
        | x  < y = contains b x
        | x > y  =  contains a x




main= do
print("Pruebas")


print("tolList")
print(toList (insert 1 empty) == [1])
print(toList (insert 10 (insert 1 empty)) == [1,10])
print(toList (insert True (insert True (insert True empty))) == [True])
print(toList (insert 5 (insert 10 (insert 1 empty))) == [1,5,10] )
--let x= Node Nil 7 Nil
