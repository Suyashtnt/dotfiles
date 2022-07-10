-- configure user config
require("user").config()

local _, err = pcall(require, "notify")
if not err then
  -- setup notifications early if they are avalible
  require("plugins.notify")
end

local _, err2 = pcall(require, "dashboard")
if not err2 then
  -- setup dashboard if avalible
  require("plugins.dashboard")
end

-- load plugins
require("plugins")

-- load keybinds
require("keybindings")
