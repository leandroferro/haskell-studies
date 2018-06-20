{--
This is my attempt to emulate echo tool 

It supports all the command line options, but -e for now is parsing just new-line and tab
--}

import System.Environment

data Options = Options { useNewLine :: Bool, parseBackslash :: Bool }
data Cmd = Help | Version | Print Options [String]

parsePrint :: Options -> [String] -> Cmd
parsePrint ops ("-n":t) = parsePrint (Options False (parseBackslash ops)) t
parsePrint ops ("-e":t) = parsePrint (Options (useNewLine ops) True) t
parsePrint ops ("-E":t) = parsePrint  (Options (useNewLine ops) False) t
parsePrint ops t = Print ops t

parseCmd :: [String] -> Cmd
parseCmd ("--version":[]) = Version
parseCmd ("--help":[]) = Help
parseCmd t = parsePrint (Options True False) t

replace :: [Char] -> [Char]
replace [] = []
replace ('\\':'n':t) = '\n' : replace t
replace ('\\':'t':t) = '\t' : replace t
replace (h:t) = h : replace t

joinAndPrint :: (String -> IO ()) -> [String] -> IO ()
joinAndPrint printer t = printer $ unwords t

getPrinter :: Bool -> String -> IO ()
getPrinter True = putStrLn
getPrinter False = putStr

executePrint :: Cmd -> IO ()
executePrint (Print ops t) =
  case parseBackslash ops of
    False -> joinAndPrint printer t
    True -> joinAndPrint printer (map replace t)
  where printer = getPrinter (useNewLine ops)

executeCmd :: Cmd -> IO ()
executeCmd Help = putStrLn "This is help"
executeCmd Version = putStrLn "This is version"
executeCmd printCmd = executePrint printCmd

main :: IO ()
main = do
  args <- getArgs
  executeCmd $ parseCmd args
