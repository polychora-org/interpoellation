#!/usr/bin/env stack
-- stack --resolver lts-12.20 script
import Control.Arrow (first, second)
import Control.Monad (guard)
import Data.Array
import Data.List (minimumBy, intersect)
import Data.Ord (comparing)
import Debug.Trace (traceShowId)
import System.Environment (getArgs)
import System.Process (readProcess)
import Text.Regex.PCRE

type Phoneme = String

phonemes :: String -> [Phoneme]
phonemes x = getAllTextMatches (x =~ "Z|z|x|w|V|v|U@|U@|U|u:|tS|T|t|S|s|r|p|oU|OI|O@|O@|O:|o@|N|n^|n|m|@L|l^|l|k|j|I2|I|i@|i@|i:|i|h|g|f|eI|E|e@|e@|dZ|D|d|C|b|aU@|aU|aI@|aI|aa|A@|A@|A:|a#|a|@5|3:|3:|3|@2|0|@|'| ")

getPhonemes :: String -> IO [Phoneme]
getPhonemes x = do
  output <- readProcess "espeak" ["-q", "-x", x] ""
  pure (phonemes (tail output))

intermediates :: [Phoneme] -> [Phoneme] -> [String]
intermediates xs ys =
  let (_, xxs) = editDistance xs ys
  in map (\xs -> "[[" ++ concat xs ++ "]]") xxs

data EditOp = Insert Int Int | Delete Int Int | Replace Int Int
  deriving (Eq, Show)

editDistance :: Eq a => [a] -> [a] -> (Int, [[a]])
editDistance xs ys = second backtrace $ table ! (m,n)
    where
    (m,n) = (length xs, length ys)
    x     = array (1,m) (zip [1..] xs)
    y     = array (1,n) (zip [1..] ys)

    table = array bnds [(ij, dist ij) | ij <- range bnds]
    bnds  = ((0,0),(m,n))
    backtrace = scanl f xs
      where
        f acc (Delete i j) = let (start, rest) = splitAt (i - 1) acc in start ++ drop 1 rest
        f acc (Insert i j) = let (start, rest) = splitAt i acc in start ++ [y ! j] ++ rest
        f acc (Replace i j) = let (start, rest) = splitAt (i - 1) acc in start ++ [y ! j] ++ drop 1 rest

    dist (0,j) = (j, map (Insert 0) [j, j-1..1])
    dist (i,0) = (i, map (flip Delete $ 1) [i, i-1..1])
    dist (i,j) = minimumBy (comparing fst) [
        second (Insert i j:) $ first (+1) $ table ! (i,j-1),
        second (Delete i j:) $ first (+1) $ table ! (i-1,j),
        if x ! i == y ! j
        then table ! (i-1,j-1)
        else second (Replace i j:) $ first (1+) $ table ! (i-1,j-1)]

main :: IO ()
main = do
  args <- getArgs
  case args of
    [x, y] -> do
      xPhon <- getPhonemes x
      yPhon <- getPhonemes y
      mapM_ putStrLn (intermediates xPhon yPhon)
      mapM_ putStrLn (init . tail $ intermediates yPhon xPhon)
    _ -> putStrLn "Usage: ./gen_utterances.hs \"word or phrase\" \"world of rays\""
