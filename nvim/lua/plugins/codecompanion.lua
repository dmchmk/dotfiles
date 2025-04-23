require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "deepseek",
    },
    inline = {
      adapter = "deepseek",
    },
    cmd = {
      adapter = "deepseek",
    }
  },
  adapters = {
    deepseek = function()
      return require("codecompanion.adapters").extend("deepseek", {
          env = {
            api_key = (function()
              local path = os.getenv("HOME") .. "/.config/deepseek_api_key"
              local file = io.open(path, "r")
              if not file then
                vim.notify("Deepseek API key not found at " .. path, vim.log.levels.WARN)
                return nil
              end
              local content = file:read("*a"):gsub("%s+", "")
              file:close()
              return content
            end)(),
          },
        schema = {
          model = {
            default = "deepseek-chat",
          },
        },
      })
    end,
  },
})
