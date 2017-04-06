  
module InputMethods where
import Control.Monad  
import Data.Char
import System.IO  
import Data.List


--main = do  
--    a <- getLine  
--    b <- getLine  
--    c <- getLine  
--    print [a,b,c]
    
--main = do  
--    rs <- sequence [getLine, getLine, getLine]  
--    print rs    



  
--main = forever $ do  
--    putStr "Give me some input: "  
--    l <- getLine  
--    putStrLn $ map toUpper l    


  
--main = do  
--    contents <- getContents  
--    putStr (map toUpper contents)  
--    
--shortLinesOnly :: String -> String  
--shortLinesOnly input =   
--    let allLines = lines input  
--        shortLines = filter (\line -> length line < 10) allLines  
--        result = unlines shortLines  
--    in  result      
    

  
--main = do  
--    handle <- openFile "C:\\Users\\Xavier\\workspace\\AccessingFiles\\src\\file.txt" ReadMode  
--    contents <- hGetContents handle  
--    putStrLn contents  
--    hClose handle   
    
columnize :: String -> [[String]]  
columnize "" =[]  
columnize x=map words(lines x)
  
flatten :: [[String]] -> String  
flatten [] =""
flatten x=unlines (map unwords x)

sortByColumn :: Int -> [[String]] -> [[String]]
sortByColumn n x 
 | n=0 = 

  
  
main = do     
print ("Testcases")
--    contents <- readFile "C:\\Users\\Xavier\\workspace\\AccessingFiles\\src\\file.txt"     
--    writeFile "C:\\Users\\Xavier\\workspace\\AccessingFiles\\src\\file1.txt" (map toUpper contents)  
--    
--  print(columnize "" == []                                                                                                                  )
--  print(columnize "Something 0 1" == [["Something", "0", "1"]]                                                                              )
--  print(columnize "Freddie   11  22\nFish 333  444 555" == [["Freddie", "11", "22"], ["Fish", "333", "444", "555"]]                         )
--  print(columnize "Jako   23    99\nEva    42    5000\nKatka  0     2" == [["Jako", "23", "99"], ["Eva", "42", "5000"], ["Katka", "0", "2"]])
  
  
--  print(flatten [] == ""                                                                                                     )
--  print(flatten [["Something", "0", "1"]] == "Something 0 1\n"                                                               )
--  print(flatten [["Jako", "23", "99"], ["Eva", "42", "5000"], ["Katka", "0", "2"]] == "Jako 23 99\nEva 42 5000\nKatka 0 2\n" )

--print(sortByColumn 0 (columnize "Jako   23    99\nEva    42    5000\nKatka  0     2") == [["Eva", "42", "5000"], ["Jako", "23", "99"], ["Katka", "0", "2"]]  )
--print(sortByColumn 1 (columnize "Jako   23    99\nEva    42    5000\nKatka  0     2") == [["Katka", "0", "2"], ["Jako", "23", "99"], ["Eva", "42", "5000"]]  )
--print(sortByColumn 2 (columnize "Jako   23    99\nEva    42    5000\nKatka  0     2") == [["Katka", "0", "2"], ["Eva", "42", "5000"], ["Jako", "23", "99"]]  )
--    
    
    
    
    
    
    
     