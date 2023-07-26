local M = {}

M.setup = function()
    local source = require('cmp-github-issues');
    require('cmp').register_source('github_issues', source.new())
end

return M
