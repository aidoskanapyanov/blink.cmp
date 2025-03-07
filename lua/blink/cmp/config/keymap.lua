--- @alias blink.cmp.KeymapCommand
--- | 'fallback' Fallback to the built-in behavior
--- | 'show' Show the completion window
--- | 'show_and_insert' Show the completion window and select the first item
--- | 'hide' Hide the completion window
--- | 'cancel' Cancel the current completion, undoing the preview from auto_insert
--- | 'accept' Accept the current completion item
--- | 'accept_and_enter' Accept the current completion item and feed an enter key to neovim (i.e. to execute the current command in cmdline mode)
--- | 'select_and_accept' Select the first completion item, if there's no selection, and accept
--- | 'select_accept_and_enter' Select the first completion item, if there's no selection, accept and feed an enter key to neovim (i.e. to execute the current command in cmdline mode)
--- | 'select_prev' Select the previous completion item
--- | 'select_next' Select the next completion item
--- | 'show_documentation' Show the documentation window
--- | 'hide_documentation' Hide the documentation window
--- | 'scroll_documentation_up' Scroll the documentation window up
--- | 'scroll_documentation_down' Scroll the documentation window down
--- | 'show_signature' Show the signature help window
--- | 'hide_signature' Hide the signature help window
--- | 'snippet_forward' Move the cursor forward to the next snippet placeholder
--- | 'snippet_backward' Move the cursor backward to the previous snippet placeholder
--- | (fun(cmp: blink.cmp.API): boolean?) Custom function where returning true will prevent the next command from running

--- @alias blink.cmp.KeymapPreset
--- | 'none' No keymaps
--- Mappings similar to the built-in completion:
--- ```lua
--- {
---   ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
---   ['<C-e>'] = { 'cancel', 'fallback' },
---   ['<C-y>'] = { 'select_and_accept' },
---
---   ['<Up>'] = { 'select_prev', 'fallback' },
---   ['<Down>'] = { 'select_next', 'fallback' },
---   ['<C-p>'] = { 'select_prev', 'fallback' },
---   ['<C-n>'] = { 'select_next', 'fallback' },
---
---   ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
---   ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
---
---   ['<Tab>'] = { 'snippet_forward', 'fallback' },
---   ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
---
---   ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
--- }
--- ```
--- | 'default'
--- Mappings similar to VSCode.
--- You may want to set `completion.trigger.show_in_snippet = false` or use `completion.list.selection.preselect = function(ctx) return not require('blink.cmp').snippet_active({ direction = 1 }) end` when using this mapping:
--- ```lua
--- {
---   ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
---   ['<C-e>'] = { 'cancel', 'fallback' },
---
---   ['<Tab>'] = {
---     function(cmp)
---       if cmp.snippet_active() then return cmp.accept()
---       else return cmp.select_and_accept() end
---     end,
---     'snippet_forward',
---     'fallback'
---   },
---   ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
---
---   ['<Up>'] = { 'select_prev', 'fallback' },
---   ['<Down>'] = { 'select_next', 'fallback' },
---   ['<C-p>'] = { 'select_prev', 'fallback' },
---   ['<C-n>'] = { 'select_next', 'fallback' },
---
---   ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
---   ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
--- }
--- ```
--- | 'super-tab'
--- Similar to 'super-tab' but with `enter` to accept
--- You may want to set `completion.list.selection.preselect = false` when using this keymap:
--- ```lua
--- {
---   ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
---   ['<C-e>'] = { 'cancel', 'fallback' },
---   ['<CR>'] = { 'accept', 'fallback' },
---
---   ['<Tab>'] = { 'snippet_forward', 'fallback' },
---   ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
---
---   ['<Up>'] = { 'select_prev', 'fallback' },
---   ['<Down>'] = { 'select_next', 'fallback' },
---   ['<C-p>'] = { 'select_prev', 'fallback' },
---   ['<C-n>'] = { 'select_next', 'fallback' },
---
---   ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
---   ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
--- }
--- ```
--- | 'enter'

--- Your custom key mappings are merged with a `preset` and any conflicting keys will overwrite the preset mappings. The `fallback` command will run the next non blink keymap.
---
--- Each keymap may be a list of commands and/or functions, where commands map directly to `require('blink.cmp')[command]()`. If the command/function returns `false` or `nil`, the next command/function will be run.
---
--- Example:
---
--- ```lua
--- keymap = {
---   -- set to 'none' to disable the 'default' preset
---   preset = 'default',
---
---   ['<Up>'] = { 'select_prev', 'fallback' },
---   ['<Down>'] = { 'select_next', 'fallback' },
---
---   -- disable a keymap from the preset
---   ['<C-e>'] = {},
---
---   -- show with a list of providers
---   ['<C-space>'] = { function(cmp) cmp.show({ providers = { 'snippets' } }) end },
---
---   -- control whether the next command will be run when using a function
---   ['<C-n>'] = {
---     function(cmp)
---       if some_condition then return end -- runs the next command
---       return true -- doesn't run the next command
---     end,
---     'select_next'
---   },
--- }
--- ```
---
--- When defining your own keymaps without a preset, no keybinds will be assigned automatically.
--- @class (exact) blink.cmp.KeymapConfig
--- @field preset? blink.cmp.KeymapPreset
--- @field [string] blink.cmp.KeymapCommand[] Table of keys => commands[]

local keymap = {
  --- @type blink.cmp.KeymapConfig
  default = {
    preset = 'default',
  },
}

--- @param config blink.cmp.KeymapConfig
function keymap.validate(config)
  assert(config.cmdline == nil, '`keymap.cmdline` has been replaced with `cmdline.keymap`')
  assert(config.term == nil, '`keymap.term` has been replaced with `term.keymap`')

  local commands = {
    'fallback',
    'show',
    'show_and_insert',
    'hide',
    'cancel',
    'accept',
    'accept_and_enter',
    'select_and_accept',
    'select_accept_and_enter',
    'select_prev',
    'select_next',
    'show_documentation',
    'hide_documentation',
    'scroll_documentation_up',
    'scroll_documentation_down',
    'show_signature',
    'hide_signature',
    'snippet_forward',
    'snippet_backward',
  }
  local presets = { 'default', 'super-tab', 'enter', 'none' }

  local validation_schema = {}
  for key, value in pairs(config) do
    -- preset
    if key == 'preset' then
      validation_schema[key] = {
        value,
        function(preset) return vim.tbl_contains(presets, preset) end,
        'one of: ' .. table.concat(presets, ', '),
      }

    -- key
    else
      validation_schema[key] = {
        value,
        function(key_commands)
          for _, command in ipairs(key_commands) do
            if type(command) ~= 'function' and not vim.tbl_contains(commands, command) then return false end
          end
          return true
        end,
        'commands must be one of: ' .. table.concat(commands, ', '),
      }
    end
  end
  require('blink.cmp.config.utils')._validate(validation_schema)
end

return keymap
