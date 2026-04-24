return {
  "folke/snacks.nvim",
  init = function()
    vim.api.nvim_create_user_command("LazygitEdit", function(opts)
      local filename = opts.args

      -- Send 'q' to lazygit so it exits with code 0 (no snacks error notification)
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == "terminal" then
          local name = vim.api.nvim_buf_get_name(buf)
          if name:match("lazygit") then
            local job_id = vim.b[buf].terminal_job_id
            if job_id then
              vim.fn.jobsend(job_id, "q")
            end
            break
          end
        end
      end

      vim.schedule(function()
        -- Find the first non-terminal window to open the file in
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].buftype == "" then
            vim.api.nvim_set_current_win(win)
            break
          end
        end
        vim.cmd("edit " .. vim.fn.fnameescape(filename))
      end)
    end, { nargs = 1 })
  end,
}
