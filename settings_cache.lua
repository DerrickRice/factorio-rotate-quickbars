function split_string(strval, delimiter)
  -- https://gist.github.com/jaredallard/ddb152179831dd23b230
  local result = { }
  local from  = 1
  local delim_from, delim_to = string.find(strval, delimiter, from)
  while delim_from do
    table.insert( result, string.sub(strval, from , delim_from-1))
    from  = delim_to + 1
    delim_from, delim_to = string.find(strval, delimiter, from)
  end
  table.insert( result, string.sub( strval, from ) )
  return result
end

SettingsCache = {}

function SettingsCache:new(obj)
  obj = obj or {}
  setmetatable(obj, self)
  self.__index = self

  obj:init()
  return obj
end

function SettingsCache:init()
  self.players = {}
end

function SettingsCache:settings_hash(player)
  local mod_settings = player.mod_settings
  local settings_table = {
    mod_settings["dr_quickbar_which_bars"].value,
    mod_settings["dr_quickbar_range"].value,
    mod_settings["dr_quickbar_stepsize"].value
  }
  return table.concat(settings_table, "\0")
end

function SettingsCache:cfg(player)
  self:check_for_change(player)
  return self.players[player.index]
end

function SettingsCache:check_for_change(player)
  local player_number = player.index

  -- if we don't know this player, reset the values
  if self.players[player_number] == nil then
    self:reset_values(player)
    return true
  end

  -- if the settings hash has changed, reset the values
  if self:settings_hash(player) ~= self.players[player_number].hash then
    self:reset_values(player)
    return true
  end

  return false
end

function SettingsCache:compute_which_bars(player)
  local default = {1, 2}

  -- read and compute which_bar
  local sval = player.mod_settings["dr_quickbar_which_bars"].value
  local vals = split_string(sval, ',')
  local ivals = {}
  local haserr = false
  local seen = {}
  for i, v in ipairs(vals) do
    -- remove all whitespace
    v = string.gsub(v, "%s","")
    -- ignore empty values
    if string.len(v) > 0 then
      v = tonumber(v)
      -- detect number errors
      if v == nil then
        self:report_error(player, "Invalid setting for which bars. Not a number. Using default.")
        return default
      end

      if v < 1 then
        self:report_error(player, "Invalid setting for which bars. Less than 1. Using default.")
        return default
      end

      if v > 4 then
        self:report_error(player, "Invalid setting for which bars. Greater than 4. Using default.")
        return default
      end

      if seen[v] == true then
        self:report_error(player, "Invalid setting for which bars. Repeat value. Using default.")
      else
        seen[v] = true
        table.insert(ivals, v)
      end
    end
  end

  return ivals
end

function SettingsCache:compute_range(player)
  local default = { start = 1, length = 10 }

  -- read and compute which_bar
  local sval = player.mod_settings["dr_quickbar_range"].value
  local vals = split_string(sval, '-')
  if #vals ~= 2 then
    self:report_error(player, "Invalid setting for bar range. Incorrect format. Using default.")
    return default
  end

  local startv = tonumber((string.gsub(vals[1], "%s", "")))
  if startv == nil or startv < 1 or startv >= 10 then
    self:report_error(player, "Invalid setting for bar range. Invalid start of range. Using default.")
    return default
  end

  local endv = tonumber((string.gsub(vals[2], "%s", "")))
  if endv == nil or endv < startv or endv > 10 then
    self:report_error(player, "Invalid setting for bar range. Invalid end of range. Using default.")
    return default
  end

  return {
    start = startv,
    count = endv - startv + 1
  }
end

function SettingsCache:compute_stepsize(player)
  local default = 1

  -- read and compute which_bar
  local sval = player.mod_settings["dr_quickbar_stepsize"].value

  local ival = tonumber((string.gsub(sval, "%s", "")))
  if ival == nil or ival < 1 or ival >= 10 then
    self:report_error(player, "Invalid setting for step size. Using default.")
    return default
  end

  return ival
end

function SettingsCache:report_error(player, msg)
  player.print("RotateQuickbars::Error: "..msg)
end

function SettingsCache:reset_values(player)
  local new_info = {}

  -- set the hash, which is used to detect changes
  new_info.hash = self:settings_hash(player)
  new_info.which_bars = self:compute_which_bars(player)
  local range = self:compute_range(player)
  new_info.pages_start = range.start
  new_info.pages_count = range.count
  new_info.stepsize = self:compute_stepsize(player)

  self.players[player.index] = new_info
end

return SettingsCache:new()
