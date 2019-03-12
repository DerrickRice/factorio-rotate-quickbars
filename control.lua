function which_screen_quickbars(player)
  -- TODO: Allow the user to configure which bars this mod affects.
  -- Which screen pages to increment, decrement, or rotate
  -- screen page 1 is the "active" bar. 4 is usually the max.
  return {1, 2, 3, 4}
end

-- TODO: Allow the user to configure the range of bars for increment/decrement.
-- By default, it's 1 through 10. Can configure it to 1-5, 3-7, etc. (converts
-- to a start index and a count)
function quickbar_pages_start(player)
  return 1
end

function quickbar_pages_count(player)
  return 10
end

function quickbar_rotate_up(event)
  local player = game.players[event.player_index]
  local screen_quickbars = which_screen_quickbars(player)
  local active_page = {}

  -- determine the current active pages on each screen
  for iter_index, screen_index in ipairs(screen_quickbars) do
    active_page[iter_index] = player.get_active_quick_bar_page(screen_index)
  end

  -- rotate the active bar values
  for iter_index, screen_index in ipairs(screen_quickbars) do
    local next_iter_index = (iter_index + 1) % #screen_quickbars
    player.set_active_quick_bar_page(screen_index, active_page[next_iter_index])
  end
end

function quickbar_rotate_down(event)
  local player = game.players[event.player_index]
  local screen_quickbars = which_screen_quickbars(player)
  local active_page = {}

  -- determine the current active pages on each screen
  for iter_index, screen_index in ipairs(screen_quickbars) do
    active_page[iter_index] = player.get_active_quick_bar_page(screen_index)
  end

  -- rotate the active bar values
  for iter_index, screen_index in ipairs(screen_quickbars) do
    local next_iter_index = (iter_index - 1) % #screen_quickbars
    player.set_active_quick_bar_page(screen_index, active_page[next_iter_index])
  end
end

function quickbar_math(player, current, diff)
  local start = quickbar_pages_start(player)
  local current_offset = current - start
  local new_offset = (current + diff) % quickbar_pages_count(player)
  return start + new_offset
end

function quickbar_increment(event)
  local player = game.players[event.player_index]
  local screen_quickbars = which_screen_quickbars(player)

  for iter_index, screen_index in ipairs(screen_quickbars) do
    local incremented_page_index = quickbar_math(player, player.get_active_quick_bar_page(screen_index), 1)
    player.set_active_quick_bar_page(screen_index, incremented_page_index)
  end
end

function quickbar_decrement(event)
  local player = game.players[event.player_index]
  local screen_quickbars = which_screen_quickbars(player)

  for iter_index, screen_index in ipairs(screen_quickbars) do
    local decremented_page_index = quickbar_math(player, player.get_active_quick_bar_page(screen_index), -1)
    player.set_active_quick_bar_page(screen_index, decremented_page_index)
  end
end

-- Controls defined in data.lua
script.on_event("dr_quickbar_rotate_up", quickbar_rotate_up)
script.on_event("dr_quickbar_rotate_down", quickbar_rotate_down)
script.on_event("dr_quickbar_increment", quickbar_increment)
script.on_event("dr_quickbar_decrement", quickbar_decrement)
