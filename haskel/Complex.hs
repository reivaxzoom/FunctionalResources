module Complex where

import Data.List (insert)
newtype PQList a  = PQ [a]  deriving (Eq, Show, Ord)
data Heap a  = E|T Int a (Heap a)  (Heap a)     deriving (Show, Eq,Ord)


class PriorityQueue q  where   
    empty     :: PriorityQueue q => q a
    singleton :: (PriorityQueue q, Ord a) => a -> q a
    top       :: (PriorityQueue q, Ord a) => q a -> Maybe a 
    put       :: (PriorityQueue q, Ord a) => a -> q a -> q a
    remove    :: (PriorityQueue q, Ord a) => q a -> q a

instance PriorityQueue PQList  where
    empty        =  PQ [] 
    singleton x  =  PQ [x]
    top (PQ [] )  = Nothing 
    top (PQ (x:xs)) = Just x
    put a (PQ x)   = PQ(insert a x)   
    put a empty =singleton a
    remove (PQ [x]) = empty
    remove (PQ(x:xs))=PQ xs 
    remove (PQ[]) = empty
    
    

instance PriorityQueue Heap  where
    empty        =  E 
    singleton x  =  T 1 x E E
    top E = Nothing
    top (T _ x _ _) = Just x
    put x y = merge (T 1 x E E ) y
    remove E = E
    remove (T _ _ y z) = merge y z

rank :: Heap a -> Int
rank E =0
rank (T x _ _ _) =x        

mkT ::Ord a => a -> Heap a ->Heap a -> Heap a
mkT x y z
    |rank y == rank z = T (rank y+1 ) x y z     
    |rank y > rank z  =  T(rank z + 1) x y z
    |rank y < rank z  =  T (rank y + 1) x z y
    |otherwise = error "error"

merge :: Ord a => Heap a -> Heap a -> Heap a
merge E E = E
merge a E = a
merge E a = a
merge (T _ x y z) (T _ a b c)
    | x <= a = mkT x y (merge z (mkT a b c))
    | x> a = mkT a b (merge (mkT x y z) c) 
    |otherwise = error "error"

main=do
print "Pruebas"
print(PQ [1..10])
print(PQ [1..10] == PQ [1..10])
print(top (empty :: PQList Bool) == Nothing)
print(top (singleton True :: PQList Bool) == Just True)

print "put"
print(put 'x' (empty :: PQList Char)== singleton 'x')
print(put 'm' (put 'x' empty:: PQList Char)==PQ ['m', 'x'])
print(put 'p' (put 'm' (put 'x' empty:: PQList Char))== PQ ['m', 'p', 'x'])
print(put 'h' (put 'p' (put 'm' (put 'x' empty:: PQList Char)))==PQ ['h', 'm', 'p', 'x'])
print(top (put 'h' (put 'p' (put 'm' (put 'x' empty:: PQList Char))) )== Just 'h')

print "remove"
print(remove (empty :: PQList Bool) == empty                             )
print(remove (singleton "heap" :: PQList String) == empty                )
print(remove (put 'm' (singleton 'x')) == (singleton 'x' :: PQList Char) )
print(remove (put 'x' (singleton 'm')) == (singleton 'x' :: PQList Char) )    

print "rank"
print(rank E               ==  0 )
print(rank (T 1 'a' E E)   ==  1 )
print(rank (T 9 True E E)  ==  9 )

print "top"
print(top (empty :: Heap String) == Nothing                      )
print(top (singleton "foobar" :: Heap String) == Just "foobar"   )
print(top (mkT 'a' (singleton 'b') (singleton 'c')) == Just 'a'  )

print "mkT"
print(mkT 'x' E E  ==  T 1 'x' E E                                                                                                                        )
print(mkT 'f' (mkT 'o' (mkT 'b' (mkT 'a' E E) E) E) E  == T 1 'f' (T 1 'o' (T 1 'b' (T 1 'a' E E) E) E) E                                                 )
print(mkT "apple" (mkT "pear" E (mkT "peach" E (mkT "plum" E E))) E == T 1 "apple" (T 1 "pear" (T 1 "peach" (T 1 "plum" E E) E) E) E                      )
print(mkT 'z' (mkT 'x' (mkT 'y' E E) (mkT 'u' E E)) (mkT 'w' (mkT 'a' E E) (mkT 'b' E (mkT 'c' E E)))  == T 3 'z' (T 2 'x' (T 1 'y' E E) (T 1 'u' E E)) (T 2 'w' (T 1 'a' E E) (T 1 'b' (T 1 'c' E E) E)) )


print "merge"
print(merge (empty :: Heap Char) (empty :: Heap Char)  ==  empty  )
print(merge empty (singleton 'x':: Heap Char)  ==  singleton 'x'                                                                                                 )
print(merge (singleton 'z':: Heap Char) (singleton 'x':: Heap Char)  == T 1 'x' (T 1 'z' E E) E)
print(merge (singleton 'u':: Heap Char) (merge (singleton 'z':: Heap Char) (singleton 'x':: Heap Char))  == T 1 'u' (T 1 'x' (T 1 'z' E E) E) E                                         )
print(merge (merge (singleton 'u') (merge (singleton 'z') (singleton 'x'))) (singleton 'w')  == T 2 'u' (T 1 'x' (T 1 'z' E E) E) (T 1 'w' E E)     )

print "put"
print(put 'x' (empty :: Heap Char) == singleton 'x'                                                     )
print(put 'm' (put 'x' empty:: Heap Char) == T 1 'm' (T 1 'x' E E) E                                                )
print(put 'p' (put 'm' (put 'x' empty:: Heap Char)) == T 2 'm' (T 1 'x' E E) (T 1 'p' E E)                          )
print(put 'h' (put 'p' (put 'm' (put 'x' empty:: Heap Char))) == T 1 'h' (T 2 'm' (T 1 'x' E E) (T 1 'p' E E)) E    )

print "remove"
print(remove (empty :: Heap Bool) == empty                               )
print(remove (singleton "heap" :: Heap String) ==  empty                 )
print(remove (put 'm' (singleton 'x')) == (singleton 'x' :: Heap Char)   )
print(remove (put 'x' (singleton 'm')) == (singleton 'x' :: Heap Char)   )


