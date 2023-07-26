local M = {}

function M.setup()
    local source = require('cmp-github-issues.source');
    require('cmp').register_source('github_issues', source.new())
end

return M
