module Prueba where

{-# LANGUAGE MultiParamTypeClasses #-}

import Data.Typeable
import Data.Data
import Data.Maybe
    
    
main= do
    putStrLn "Get an Float"; a<- readLn
    putStrLn "Get another Float"; b<- readLn
    let a1 = a::Char
    let b1 = b::Char
    let c = a1 >>>b1
    
    putStrLn $(show a) ++ ">" ++ (show b) ++ "=" ++ (show c)    
--
-- data List q = Empty | Con q (List q) deriving (Show, Read, Eq, Ord) 
--type PriorityQueue q =([q],[q])   
data RPS = Rock | Paper | Scissors 
        deriving (Read, Show)
    
class Compare a b where
    (>>>) :: a -> b -> Bool
--    empty     :: PriorityQueue q => q a


instance Compare RPS RPS where
    (>>>) Rock Scissors = True
    (>>>) Scissors Paper  = True
    (>>>) Paper Rock  = True
    (>>>) _ _ = False
    
instance Compare Double Double where 
    (>>>) a b = a > b

instance Compare Int Int where
    (>>>) a b = a > b    

instance Compare Char Char where
    (>>>) a b = False    
        
    
