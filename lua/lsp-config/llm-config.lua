local llm = require('llm')
local curl = require('plenary.curl')
local M = {}

local llmDomain = "http://localhost:11434"

function M.init()
    local status, err = pcall(
        function()
            local response = curl.request({ url = llmDomain, method = "get", timeout = 500 })
            if (response.status ~= 200) then
                error("LLM Server at: '" .. llmDomain .. "' not online. Skipping llm-nvim startup")
                return
            end
        end)
    if (status) then
        llm.setup({
            lsp = { bin_path = os.getenv('HOME') .. "/.cargo/bin/llm-ls" },
            model = llmDomain .. "/api/generate",
            enable_suggestions_on_startup = true,
            enable_suggestions_on_files = "*",
            tls_skip_verify_insecure = true,
            context_window = 4096,
            fim = {
                enabled = true,
                prefix = "<fim_prefix>",
                middle = "<fim_middle>",
                suffix = "<fim_suffix>",
            },
            tokens_to_clear = { "</fim_middle>" },
            adaptor = "ollama",
            request_body = {
                model = "stable-code-3b"
            },
            query_params = {
                maxNewTokens = 256,
                temperature = 0.5,
                doSample = true,
                topP = 0.90,
            }
        })
    end
end

return M
