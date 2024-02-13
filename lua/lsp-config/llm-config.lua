local M = {}

local llmDomain = "http://localhost:11434"

function M.setup()
    local llm = require('llm')
    local curl = require('plenary.curl')

    local response = curl.request({
        url = llmDomain,
        method = "get",
        timeout = 500,
        on_error = function(e) return { status = e.exit } end
    })
    if (response.status ~= 200) then
        vim.notify("LLM Server at: '" .. llmDomain .. "' not online. Skipping llm-nvim startup")
        return
    end
    local cargoPath = os.getenv('HOME') .. "/.cargo/bin/llm-ls.exe";
    if (vim.fn.has('macunix')) then
        cargoPath = os.getenv('HOME') .. "/.cargo/bin/llm-ls"
    end
    llm.setup({
        lsp = { bin_path =  cargoPath },
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

return M
