-- code comes from: https://github.com/wincent/wincent/blob/2d926177773f/aspects/nvim/files/.config/nvim/lua/wincent/cmp/handles.lua

local issues_list = vim.fn.json_decode(vim.fn.system("gh issue list --json number,title,body", true))

local source = {}

source.new = function()
    return setmetatable({}, { __index = source })
end

source.get_trigger_characters = function()
    return { '#' }
end

source.get_keyword_pattern = function()
    return [[\%(\k\|\.\)\+]]
end

source.complete = function(self, request, callback)
    local input = string.sub(request.context.cursor_before_line, request.offset - 1)
    local prefix = string.sub(request.context.cursor_before_line, 1, request.offset - 1)

    if vim.startswith(input, '#') and (prefix == '#' or vim.endswith(prefix, ' #')) then
        local items = {}

        for _, issue in ipairs(issues_list) do
            local number = tostring(issue.number)
            local title = issue.title
            local body = issue.body

            table.insert(items, {
                filterText = title,
                label = "#" .. number .. ":" .. title,
                textEdit = {
                    newText = "#" .. number,
                    range = {
                        start = {
                            line = request.context.cursor.row - 1,
                            character = request.context.cursor.col - 1 - #input,
                        },
                        ['end'] = {
                            line = request.context.cursor.row - 1,
                            character = request.context.cursor.col - 1,
                        },
                    },
                },
                documentation = {
                    kind = 'markdown',
                    value = body
                }
            })
        end
        callback {
            items = items,
            isIncomplete = true,
        }
    else
        callback({ isIncomplete = true })
    end
end

return source;
