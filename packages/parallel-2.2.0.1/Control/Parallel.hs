-----------------------------------------------------------------------------
-- |
-- Module      :  Control.Parallel
-- Copyright   :  (c) The University of Glasgow 2001
-- License     :  BSD-style (see the file libraries/base/LICENSE)
-- 
-- Maintainer  :  libraries@haskell.org
-- Stability   :  stable
-- Portability :  portable
--
-- Parallel Constructs
--
-----------------------------------------------------------------------------

module Control.Parallel (
          par, pseq,
	  seq, -- for backwards compatibility, 6.6 exported this
#if defined(__GRANSIM__)
	, parGlobal, parLocal, parAt, parAtAbs, parAtRel, parAtForNow     
#endif
    ) where

import Prelude

#ifdef __GLASGOW_HASKELL__
import qualified GHC.Conc	( par, pseq )

infixr 0 `par`, `pseq`
#endif

#if defined(__GRANSIM__)
import PrelBase
import PrelErr   ( parError )
import PrelGHC   ( parGlobal#, parLocal#, parAt#, parAtAbs#, parAtRel#, parAtForNow# )

infixr 0 `par`

{-# INLINE parGlobal #-}
{-# INLINE parLocal #-}
{-# INLINE parAt #-}
{-# INLINE parAtAbs #-}
{-# INLINE parAtRel #-}
{-# INLINE parAtForNow #-}
parGlobal   :: Int -> Int -> Int -> Int -> a -> b -> b
parLocal    :: Int -> Int -> Int -> Int -> a -> b -> b
parAt	    :: Int -> Int -> Int -> Int -> a -> b -> c -> c
parAtAbs    :: Int -> Int -> Int -> Int -> Int -> a -> b -> b
parAtRel    :: Int -> Int -> Int -> Int -> Int -> a -> b -> b
parAtForNow :: Int -> Int -> Int -> Int -> a -> b -> c -> c

parGlobal (I# w) (I# g) (I# s) (I# p) x y = case (parGlobal# x w g s p y) of { 0# -> parError; _ -> y }
parLocal  (I# w) (I# g) (I# s) (I# p) x y = case (parLocal#  x w g s p y) of { 0# -> parError; _ -> y }

parAt       (I# w) (I# g) (I# s) (I# p) v x y = case (parAt#       x v w g s p y) of { 0# -> parError; _ -> y }
parAtAbs    (I# w) (I# g) (I# s) (I# p) (I# q) x y = case (parAtAbs#  x q w g s p y) of { 0# -> parError; _ -> y }
parAtRel    (I# w) (I# g) (I# s) (I# p) (I# q) x y = case (parAtRel#  x q w g s p y) of { 0# -> parError; _ -> y }
parAtForNow (I# w) (I# g) (I# s) (I# p) v x y = case (parAtForNow# x v w g s p y) of { 0# -> parError; _ -> y }

#endif

-- Maybe parIO and the like could be added here later.

-- | Indicates that it may be beneficial to evaluate the first
-- argument in parallel with the second.  Returns the value of the
-- second argument.
-- 
-- @a ``par`` b@ is exactly equivalent semantically to @b@.
--
-- @par@ is generally used when the value of @a@ is likely to be
-- required later, but not immediately.  Also it is a good idea to
-- ensure that @a@ is not a trivial computation, otherwise the cost of
-- spawning it in parallel overshadows the benefits obtained by
-- running it in parallel.
--
-- Note that actual parallelism is only supported by certain
-- implementations (GHC with the @-threaded@ option, and GPH, for
-- now).  On other implementations, @par a b = b@.
--
par :: a -> b -> b
#ifdef __GLASGOW_HASKELL__
par = GHC.Conc.par
#else
-- For now, Hugs does not support par properly.
par a b = b
#endif

-- | Semantically identical to 'seq', but with a subtle operational
-- difference: 'seq' is strict in both its arguments, so the compiler
-- may, for example, rearrange @a ``seq`` b@ into @b ``seq`` a ``seq`` b@.
-- This is normally no problem when using 'seq' to express strictness,
-- but it can be a problem when annotating code for parallelism,
-- because we need more control over the order of evaluation; we may
-- want to evaluate @a@ before @b@, because we know that @b@ has
-- already been sparked in parallel with 'par'.
--
-- This is why we have 'pseq'.  In contrast to 'seq', 'pseq' is only
-- strict in its first argument (as far as the compiler is concerned),
-- which restricts the transformations that the compiler can do, and
-- ensures that the user can retain control of the evaluation order.
--
pseq :: a -> b -> b
#ifdef __GLASGOW_HASKELL__
pseq = GHC.Conc.pseq
#else
pseq = seq
#endif
