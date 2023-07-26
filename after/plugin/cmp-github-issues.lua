local registered = false

if registered then
    return
end

registered = true

local has_cmp, cmp = pcall(require, 'cmp')

if not has_cmp then
    return
end

local source = require('cmp-github-issues');

require('cmp').register_source('github_issues', source.new())
