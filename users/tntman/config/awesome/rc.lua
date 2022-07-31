-- bootstrap fennel
local fennel = require("./fennel")
fennel.path = fennel.path .. ";.config/awesome/?.fnl"
table.insert(package.loaders or package.searchers, fennel.searcher)

-- load config
require("cfg")
