module Cornelis.Vim.Compat where

import Data.Int (Int64)
import Data.Text (Text)
import Data.Vector (Vector)
import qualified Data.Vector as Vector
import Neovim
import Neovim.API.Text (Buffer, Window)
import qualified Neovim.API.Text as Vim

nvim_list_wins :: Neovim env [Window]
nvim_list_wins = Vector.toList <$> Vim.nvim_list_wins

window_get_cursor :: Window -> Neovim env (Int, Int)
window_get_cursor w = do
  (r, c) <- Vim.window_get_cursor w
  pure (fromIntegral r, fromIntegral c)

window_set_cursor :: Window -> (Int, Int) -> Neovim env ()
window_set_cursor w (r, c) = Vim.window_set_cursor w (fromIntegral r, fromIntegral c)

nvim_buf_get_lines :: Buffer -> Int64 -> Int64 -> Bool -> Neovim env [Text]
nvim_buf_get_lines b s e flag = Vector.toList <$> Vim.nvim_buf_get_lines b s e flag

nvim_buf_get_lines' :: Buffer -> Int64 -> Int64 -> Bool -> Neovim env (Vector Text)
nvim_buf_get_lines' = Vim.nvim_buf_get_lines

nvim_buf_set_text ::
    Buffer -> Int64 -> Int64 -> Int64 -> Int64 -> [Text] -> Neovim env ()
nvim_buf_set_text b sl sc el ec = Vim.nvim_buf_set_text b sl sc el ec . Vector.fromList
