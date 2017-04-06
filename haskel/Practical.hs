module Practical where

data Day = Monday| Tuesday| Wednesday|Thursday|Friday|Saturday|Sunday|A 
        deriving (Eq, Ord, Show, Read, Bounded, Enum) 

type A = Int
type B = [Int]
data Tr a  = E|T  a (Tr a)        deriving (Show, Eq,Ord)
newtype AGM a   = H [a]  deriving (Show, Eq, Ord)
data Shape =Line Int Int| Triangle Int Int Int | Square Int Int Int Int deriving(Show)


 
 


--Practical> [Thursday .. Sunday]
--[Thursday,Friday,Saturday,Sunday]
--Practical> succ Monday
--Tuesday
--Practical> minBound::Day
--Monday
--Practical> maxBound::Day
--Sunday
--Practical> Saturday ==Friday
--False
--Practical> Saturday `compare` Monday
--GT
--Practical> pred Sunday
--Saturday
--Practical> H[Monday .. Friday]
--H [Monday,Tuesday,Wednesday,Thursday,Friday]


