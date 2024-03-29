--------------------------------------------------------------------------------
-- |
-- Module      :  Graphics.Rendering.OpenGL.GL.Antialiasing
-- Copyright   :  (c) Sven Panne 2002-2009
-- License     :  BSD-style (see the file libraries/OpenGL/LICENSE)
-- 
-- Maintainer  :  sven.panne@aedion.de
-- Stability   :  stable
-- Portability :  portable
--
-- This module corresponds to section 3.2 (Antialiasing) of the OpenGL 2.1
-- specs.
--
--------------------------------------------------------------------------------

module Graphics.Rendering.OpenGL.GL.Antialiasing (
   sampleBuffers, samples, multisample, subpixelBits
) where

import Graphics.Rendering.OpenGL.GL.Capability (
   EnableCap(CapMultisample), makeCapability )
import Graphics.Rendering.OpenGL.GL.BasicTypes ( GLsizei, Capability )
import Graphics.Rendering.OpenGL.GL.QueryUtils (
   GetPName(GetSampleBuffers,GetSamples,GetSubpixelBits), getSizei1 )
import Graphics.Rendering.OpenGL.GL.StateVar (
   GettableStateVar, makeGettableStateVar, StateVar )

--------------------------------------------------------------------------------

sampleBuffers :: GettableStateVar GLsizei
sampleBuffers = antialiasingInfo GetSampleBuffers

samples :: GettableStateVar GLsizei
samples = antialiasingInfo GetSamples

multisample :: StateVar Capability
multisample = makeCapability CapMultisample

subpixelBits :: GettableStateVar GLsizei
subpixelBits = antialiasingInfo GetSubpixelBits

antialiasingInfo :: GetPName -> GettableStateVar GLsizei
antialiasingInfo = makeGettableStateVar . getSizei1 id
