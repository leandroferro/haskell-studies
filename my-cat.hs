{--
This is my attempt to emulate cat tool.
--}

import System.Environment

cat file = readFile file >>= putStr 

main :: IO ()
main = getArgs >>= mapM_ cat
