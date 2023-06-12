local module = {}
module.fzymru_filepath = os.getenv('HOME') .. '/.mru'
module.fzymru_path = "fzy"
--- TODO fzy doesn't have options to search in the filename only, not in the whole file path
module.fzymru_args = ""
module.fzymru_history = 20

function read_mru()
    local mru = {}
    local f = io.open(module.fzymru_filepath)
    if f == nil then return end
    for line in f:lines() do
        table.insert(mru, line)
    end
    f:close()

    return mru
end

function write_mru(win)
    local file_path = win.file.path
    local mru = read_mru()

    -- check if mru data exists
    if mru == nil then mru = {} end
    -- check if we opened any file
    if file_path == nil then return end
    -- check duplicate
    if file_path == mru[1] then return end

    local f = io.open(module.fzymru_filepath, 'w+')
    if f == nil then return end

    table.insert(mru, 1, file_path)

    for i,k in ipairs(mru) do
        if i > module.fzymru_history then break end
        if i == 1 or k ~= file_path then
            f:write(string.format('%s\n', k))
        end
    end

    f:close()
end

vis.events.subscribe(vis.events.WIN_OPEN, write_mru)

vis:command_register("fzymru", function(argv, force, win, selection, range)
    local command = "cat " .. module.fzymru_filepath .. " | " .. module.fzymru_path .. " " .. module.fzymru_args .. " " .. table.concat(argv, " ")

	--- Using io.popen() leads to staircase effect, the tty needs to be handled correctly
	--- with fzy (in contrast to fzf)
	--- TODO use nil for file parameter
	local status, output, stderr = vis:pipe(win.file, {start = 0, finish = 0}, command)
	-- local status, output, stderr = vis:pipe(nil, nil, command)


    if status == 0 then
		--- Remove trailing newline
        vis:command(string.format("e '%s'", output:sub(1, -2)))
    end

    vis:redraw()

    return true;
end)

return module
