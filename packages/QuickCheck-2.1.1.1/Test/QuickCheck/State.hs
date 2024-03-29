module Test.QuickCheck.State where

import Test.QuickCheck.Text
import System.Random( StdGen )

--------------------------------------------------------------------------
-- State

-- | State represents QuickCheck's internal state while testing a property.
-- | The state is made visible to callback functions.
data State
  = MkState
  -- static
  { terminal          :: Terminal   -- ^ the current terminal
  , maxSuccessTests   :: Int        -- ^ maximum number of successful tests needed
  , maxDiscardedTests :: Int        -- ^ maximum number of tests that can be discarded
  , computeSize       :: Int -> Int -> Int -- ^ how to compute the size of test cases from
                                    -- #tests and #discarded tests
  
  -- dynamic
  , numSuccessTests   :: Int        -- ^ the current number of tests that have succeeded
  , numDiscardedTests :: Int        -- ^ the current number of discarded tests
  , collected         :: [[(String,Int)]] -- ^ all labels that have been collected so far
  , expectedFailure   :: Bool       -- ^ indicates if the property is expected to fail
  , randomSeed        :: StdGen     -- ^ the current random seed
  
  -- shrinking
  , isShrinking       :: Bool       -- ^ are we in a shrinking phase?
  , numSuccessShrinks :: Int        -- ^ number of successful shrinking steps so far
  , numTryShrinks     :: Int        -- ^ number of failed shrinking steps since the last successful shrink
  }

--------------------------------------------------------------------------
-- the end.
