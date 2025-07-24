local M = {}
local NIL = "<NIL>"

local unpack = table.unpack or unpack

M.ARC_REPO_ROOT_ENV = "ARC_ROOT"

M._arc_repo_roots = {
    "/home/dmchumak/arcadia/",
}

local is_windows = vim.loop.os_uname().version:match("Windows")

M.table = (function()
    -- finds the index of value in the table
    ---@param t table
    ---@param value any
    ---@return integer?
    local function find(t, value)
        for ix, ix_value in ipairs(t) do
            if ix_value == value then
                return ix
            end
        end
        return nil
    end

    return {
        find = find,
    }
end)()

M.path = (function()
    -- stolen form
    -- https://github.com/neovim/nvim-lspconfig/tree/71b39616b14c152da34fcc787fa27f09bf280e72/lua/lspconfig/util.lua#L124
    local function is_fs_root(path)
        if is_windows then
            return path:match("^%a:$")
        else
            return path == "/"
        end
    end

    -- stolen from https://github.com/neovim/nvim-lspconfig/tree/71b39616b14c152da34fcc787fa27f09bf280e72/lua/lspconfig/util.lua#L142
    ---@param path string
    ---@return string?
    local function dirname(path)
        local strip_dir_pat = "/([^/]+)$"
        local strip_sep_pat = "/$"
        if not path or #path == 0 then
            return
        end
        local result = path:gsub(strip_sep_pat, ""):gsub(strip_dir_pat, "")
        if #result == 0 then
            if is_windows then
                return path:sub(1, 2):upper()
            else
                return "/"
            end
        end
        return result
    end

    return {
        is_fs_root = is_fs_root,
        dirname = dirname,
    }
end)()

if os.getenv(M.ARC_REPO_ROOT_ENV) then
    table.insert(M._arc_repo_roots, 1, os.getenv(M.ARC_REPO_ROOT_ENV))
end

function M.is_inside_arc(path)
    for _, prefix in ipairs(M._arc_repo_roots) do
        if path:find(prefix, 1, true) == 1 then
            return true
        end
    end

    return false
end

function M.is_ok_root_dir(path)
    -- local util = require("dgronskiy_nvim.util")

    if M.path.is_fs_root(path) then
        return false
    end

    if path == os.getenv("HOME") then
        return false
    end

    -- No-Go's:
    -- * /data/a/trunk
    -- * /data/a/dev
    -- * /data/a/MLDWH-XXX
    local path_and_parent = { path, M.path.dirname(path) }
    for _, check_against in ipairs(M._arc_repo_roots) do
        if M.table.find(path_and_parent, check_against) then
            return false
        end
    end

    return true
end

-- TODO: move ok_root_dirs into global config file

-- root_dir function in terms of `lspconfig`. Get inspiration here:
-- https://github.com/neovim/nvim-lspconfig/tree/bfdf2e91e7297a54bcc09d3e092a12bff69a1cf4/lua/lspconfig/util.lua#L268
function M.guarded_pyright_root_directory(startpath)
    local is_inside_arc = M.is_inside_arc(startpath)
    local root_dir = nil

    if is_inside_arc then
        local util = require("lspconfig.util")
        root_dir = util.root_pattern("pyrightconfig.json")(startpath)
    else
        -- use default from here
        -- https://github.com/neovim/nvim-lspconfig/blob/d1871c84b218931cc758dbbde1fec8e90c6d465c/lua/lspconfig/configs/pyright.lua#L47
        root_dir = require("lspconfig.configs.pyright").default_config.root_dir(startpath)
    end

    local is_ok_root_dir = M.is_ok_root_dir(root_dir)
    root_dir = is_ok_root_dir and root_dir or nil

    -- if not M.is_ok_root_dir(root_dir) then
    --     logger:warn("patching
    --     vim.notify(
    --         "Inside Arc="
    --         .. tostring(is_inside_arc)
    --         .. "\nFile= "
    --         .. startpath
    --         .. "\nRoot dir= "
    --         .. root_dir
    --         .. "\n\nPatching root_dir to nil"
    --     )
    --     root_dir = nil
    -- end
    return root_dir
end

-- func! GetArcanumLink(mode)
--     let l:root = system("arc root")
--     let l:link = "https://a.yandex-team.ru/arc_vcs/" . expand("%:p")[len(l:root):]
--     if a:mode == "normal"
--         return l:link . "\\#L" . getcurpos()[1]
--     else
--         let l:start = getpos("'<")
--         let l:finish = getpos("'>")
--         return l:link . "\\#L" . l:start[1] . "-" . l:finish[1]
--     endif
-- endf

---comment
---@return string? # nil in case of an error
function M.GetArcRoot()
    local stdout = vim.fn.system("arc root 2>/dev/null")
    if vim.api.nvim_get_vvar("shell_error") ~= 0 then
        print(stdout)
        return
    end
    return stdout:gsub("\n", "")
end

---
---@param file_path string
---@param arc_root string
---@return string? # nil in case of en error
function M.GetArcRelativePath(file_path, arc_root)
    if string.sub(arc_root, -1, -1) ~= "/" then
        arc_root = arc_root .. "/"
    end

    if string.sub(file_path, 1, string.len(arc_root)) ~= arc_root then
        print(string.format("file_path [%s] is not in the repo [%s]", file_path, arc_root))
        return
    end

    local file_relative_path = string.sub(file_path, string.len(arc_root) + 1)
    return file_relative_path
end

---
---@return string? # nil in case of an error
function M.GetArcHeadCommit()
    local stdout = vim.fn.system("arc rev-parse HEAD 2>/dev/null")
    if vim.api.nvim_get_vvar("shell_error") ~= 0 then
        print(stdout)
        return
    end

    return stdout:gsub("\n", "")
end

---comment
---@return string?  # nil in case of an error
function M.GetArcanumLink(opts)
    local url_lines_requester = (function(opts)
        local line1, line2
        if opts and opts.linerange then
            line1, line2 = unpack(opts.linerange)
        else
            line1 = vim.api.nvim_win_get_cursor(0)[1]
            line2 = line1
        end

        -- print(vim.inspect(line1))

        line1, line2 = math.min(line1, line2), math.max(line1, line2)
        if line1 == line2 then
            return "#L" .. tostring(line1)
        else
            return "#L" .. tostring(line1) .. "-" .. tostring(line2)
        end
    end)(opts)

    local arc_root = M.GetArcRoot()
    if not arc_root then
        return
    end

    local file_path = vim.fn.expand("%:p") ---@type string
    local file_relative_path = M.GetArcRelativePath(file_path, arc_root)
    if not file_relative_path then
        return
    end

    local revision = M.GetArcHeadCommit()
    revision = revision and ("?rev=" .. revision) or ""

    local url = "https://a.yandex-team.ru/arcadia/" .. file_relative_path .. revision .. url_lines_requester
    return url

    -- return "https://a.yandex-team.ru/arcadia/" ..  .. "#L"
    --?rev=r14586396#L10
end

---@param link string
---@return nil
function M.ArcLinkOpen(link)
    -- https://a.yandex-team.ru/arcadia/ads/libs/py_rearrange/__init__.py#L96
    local prefix = "https://a.yandex-team.ru/arcadia"
end

return M
