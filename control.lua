local settings_cache = require("settings_cache")

-- settings_cache:cfg(player) -->
-- {
--    which_bars --> table such as {1,2,3,4}
--    pages_start --> int
--    pages_count --> int
--    stepsize --> int
-- }

function quickbar_rotate_up(event)
  local player = game.players[event.player_index]
  local cfg = settings_cache:cfg(player)
  local active_page = {}

  -- determine the current active pages on each screen
  for iter_index, screen_index in ipairs(cfg.which_bars) do
    active_page[iter_index] = player.get_active_quick_bar_page(screen_index)
  end

  -- rotate the active bar values
  for iter_index, screen_index in ipairs(cfg.which_bars) do
    local next_iter_index = iter_index + 1
    if next_iter_index > #cfg.which_bars then
      next_iter_index = next_iter_index - #cfg.which_bars
    end
    player.set_active_quick_bar_page(screen_index, active_page[next_iter_index])
  end
end

function quickbar_rotate_down(event)
  local player = game.players[event.player_index]
  local cfg = settings_cache:cfg(player)
  local active_page = {}

  -- determine the current active pages on each screen
  for iter_index, screen_index in ipairs(cfg.which_bars) do
    active_page[iter_index] = player.get_active_quick_bar_page(screen_index)
  end

  -- rotate the active bar values
  for iter_index, screen_index in ipairs(cfg.which_bars) do
    local next_iter_index = iter_index - 1
    if next_iter_index <= 0 then
      next_iter_index = next_iter_index + #cfg.which_bars
    end
    player.set_active_quick_bar_page(screen_index, active_page[next_iter_index])
  end
end

function quickbar_math(cfg, current, diff)
  local current_offset = current - cfg.pages_start
  local new_offset = (current_offset + (diff * cfg.stepsize)) % cfg.pages_count
  return cfg.pages_start + new_offset
end

function quickbar_increment(event)
  local player = game.players[event.player_index]
  local cfg = settings_cache:cfg(player)

  for iter_index, screen_index in ipairs(cfg.which_bars) do
    local current = player.get_active_quick_bar_page(screen_index)
    local incremented_page_index = quickbar_math(cfg, player.get_active_quick_bar_page(screen_index), 1)
    player.set_active_quick_bar_page(screen_index, incremented_page_index)
  end
end

function quickbar_decrement(event)
  local player = game.players[event.player_index]
  local cfg = settings_cache:cfg(player)

  for iter_index, screen_index in ipairs(cfg.which_bars) do
    local decremented_page_index = quickbar_math(cfg, player.get_active_quick_bar_page(screen_index), -1)
    player.set_active_quick_bar_page(screen_index, decremented_page_index)
  end
end

-- Controls defined in data.lua
script.on_event("dr_quickbar_rotate_up", quickbar_rotate_up)
script.on_event("dr_quickbar_rotate_down", quickbar_rotate_down)
script.on_event("dr_quickbar_increment", quickbar_increment)
script.on_event("dr_quickbar_decrement", quickbar_decrement)
