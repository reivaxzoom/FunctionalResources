module Prueba6 where

--import Prelude hiding ((+))
newtype Natural = MakeNatural Integer

toNatural               :: Integer -> Natural
toNatural x | x < 0     = error "Can't create negative naturals!" 
            | otherwise = MakeNatural x

fromNatural             :: Natural -> Integer
fromNatural (MakeNatural i) = i


instance Num Natural where
    fromInteger         = toNatural
    x + y               = toNatural (fromNatural x + fromNatural y)
    x - y               = let r = fromNatural x - fromNatural y in
                            if r < 0 then error "Unnatural subtraction"
                                     else toNatural r
    x * y               = toNatural (fromNatural x * fromNatural y)
    
    
class PriorityQueue q  where   
    empty     :: PriorityQueue q => q a
    singleton :: (PriorityQueue q, Ord a) => a -> q a
    top       :: (PriorityQueue q, Ord a) => q a -> Maybe a
    put       :: (PriorityQueue q, Ord a) => a -> q a -> q a
    remove    :: (PriorityQueue q, Ord a) => q a -> q a   
    
--instance  PriorityQueue [] where 
--        empty _= []   
    