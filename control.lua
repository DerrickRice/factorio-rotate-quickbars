-- player.get_active_quick_bar_page(x) starts at x=1 and goes to x=10.
-- Answer is the page number, minus 1. (So page 1 is 0. Page 0 is 9)

function list_screen_pages(player)
  -- Which screen pages to incremend, decrement, or rotate
  -- screen page 1 is the "active" bar. 4 is usually the max.
  return {1, 2, 3, 4}

  -- TODO: (pending additional mod API, read how many pages the user has open.
  -- TODO: Allow the user to configure which bars this mod affects.
end

-- TODO: Allow the user to configure the range of bars for increment/decrement.
-- By default, it's 0 through 9. Can configure it to 0-5, 3-7, etc. (converts
-- to a start index and a count)
function quickbar_pages_start()
  return 0
end

function quickbar_pages_count()
  return 10
end

function quickbar_rotate_up(event)
  local player = game.players[event.player_index]
  local screen_pages = list_screen_pages(player)
  local active_page = {}

  if not player.game_view_settings.show_quickbar then
    return
  end

  player.game_view_settings.show_quickbar = false

  -- determine the current active pages on each screen
  for iter_index, screen_index in ipairs(screen_pages) do
    active_page[iter_index] = player.get_active_quick_bar_page(screen_index)
  end

  -- rotate the active bar values
  for iter_index, screen_index in ipairs(screen_pages) do
    local next_iter_index = (iter_index + 1) % #screen_pages
    player.set_active_quick_bar_page(screen_index, active_page[next_iter_index])
  end

  player.game_view_settings.show_quickbar = true
end

function quickbar_rotate_down(event)
  local player = game.players[event.player_index]
  local screen_pages = list_screen_pages(player)
  local active_page = {}

  if not player.game_view_settings.show_quickbar then
    return
  end

  player.game_view_settings.show_quickbar = false

  -- determine the current active pages on each screen
  for iter_index, screen_index in ipairs(screen_pages) do
    active_page[iter_index] = player.get_active_quick_bar_page(screen_index)
  end

  -- rotate the active bar values
  for iter_index, screen_index in ipairs(screen_pages) do
    local next_iter_index = (iter_index - 1) % #screen_pages
    player.set_active_quick_bar_page(screen_index, active_page[next_iter_index])
  end

  player.game_view_settings.show_quickbar = true
end

function quickbar_increment(event)
  local player = game.players[event.player_index]
  local screen_pages = list_screen_pages(player)
  local active_page = {}

  if not player.game_view_settings.show_quickbar then
    return
  end

  player.game_view_settings.show_quickbar = false

  -- TODO: use quickbar pages start and quickbar pages length
  for iter_index, screen_index in ipairs(screen_pages) do
    local incremented_page_index = (player.get_active_quick_bar_page(screen_index) + 1) % 10
    player.set_active_quick_bar_page(screen_index, incremented_page_index)
  end

  player.game_view_settings.show_quickbar = true
end

function quickbar_decrement(event)
  local player = game.players[event.player_index]
  local screen_pages = list_screen_pages(player)
  local active_page = {}

  if not player.game_view_settings.show_quickbar then
    return
  end

  player.game_view_settings.show_quickbar = false

  -- TODO: use quickbar pages start and quickbar pages length
  for iter_index, screen_index in ipairs(screen_pages) do
    local decremented_page_index = (player.get_active_quick_bar_page(screen_index) - 1) % 10
    player.set_active_quick_bar_page(screen_index, decremented_page_index)
  end

  player.game_view_settings.show_quickbar = true
end

-- Controls defined in data.lua
script.on_event("dr_quickbar_rotate_up", quickbar_rotate_up)
script.on_event("dr_quickbar_rotate_down", quickbar_rotate_down)
script.on_event("dr_quickbar_increment", quickbar_increment)
script.on_event("dr_quickbar_decrement", quickbar_decrement)
