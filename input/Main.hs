module Main where
  
import Data.List
import Data.Function
import System.IO
import System.Environment   
  
columnize :: String -> [[String]]  
columnize "" =[]  
columnize x=map words(lines x)
  
flatten :: [[String]] -> String  
flatten [] =""
flatten x=unlines (map unwords x)

sortByColumn ::  Int -> [[String]] -> [[String]]
sortByColumn _ [] = []
sortByColumn x y = sortBy (compare `on` (!!x)) y
  
  
main :: IO ()
main = do
 print("Start main")
 param    <- getArgs                 -- getting args from cmd line
 inp   <- readFile (param !! 0)      --  reading in file
 let col = read (param !! 2) :: Int  -- reading column number
 let out = flatten ( sortByColumn col (columnize inp)) --sorting
 writeFile (param !! 1) out           --writing out sort file
 print("end")


-- :main "C:\\Users\\Xavier\\workspace\\AccessingFiles\\src\\input.txt" "C:\\Users\\Xavier\\workspace\\AccessingFiles\\src\\output.txt" 2

  
--  print(columnize "" == []                                                                                                                  )
--  print(columnize "Something 0 1" == [["Something", "0", "1"]]                                                                              )
--  print(columnize "Freddie   11  22\nFish 333  444 555" == [["Freddie", "11", "22"], ["Fish", "333", "444", "555"]]                         )
--  print(columnize "Jako   23    99\nEva    42    5000\nKatka  0     2" == [["Jako", "23", "99"], ["Eva", "42", "5000"], ["Katka", "0", "2"]])
--
--  print(flatten [] == ""                                                                                                     )
--  print(flatten [["Something", "0", "1"]] == "Something 0 1\n"                                                               )
--  print(flatten [["Jako", "23", "99"], ["Eva", "42", "5000"], ["Katka", "0", "2"]] == "Jako 23 99\nEva 42 5000\nKatka 0 2\n" )
--
--  print(sortByColumn 0 (columnize "Jako   23    99\nEva    42    5000\nKatka  0     2") == [["Eva", "42", "5000"], ["Jako", "23", "99"], ["Katka", "0", "2"]]  )
--  print(sortByColumn 1 (columnize "Jako   23    99\nEva    42    5000\nKatka  0     2") == [["Katka", "0", "2"], ["Jako", "23", "99"], ["Eva", "42", "5000"]]  )
--  print(sortByColumn 2 (columnize "Jako   23    99\nEva    42    5000\nKatka  0     2") == [["Katka", "0", "2"], ["Eva", "42", "5000"], ["Jako", "23", "99"]]  )


