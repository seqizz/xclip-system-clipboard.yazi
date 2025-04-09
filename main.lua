-- Meant to run at async context

local selected_or_hovered = ya.sync(function()
  local tab, paths = cx.active, {}
  for _, u in pairs(tab.selected) do
    paths[#paths + 1] = tostring(u)
  end
  if #paths == 0 and tab.current.hovered then
    paths[1] = tostring(tab.current.hovered.url)
  end
  return paths
end)

return {
  entry = function()
    ya.manager_emit('escape', { visual = true })

    local urls = selected_or_hovered()

    if #urls == 0 then
      return ya.notify({
        title = 'System Clipboard',
        content = 'No file selected',
        level = 'warn',
        timeout = 5,
      })
    end

    -- Format the URLs as file:// URIs
    local formatted_urls = {}
    for _, url in ipairs(urls) do
      -- If the URL doesn't already start with file://, add it
      if not url:match('^file://') then
        url = 'file://' .. url
      end
      formatted_urls[#formatted_urls + 1] = url
    end

    -- Create the uri-list content (no trailing newline)
    local uri_list = table.concat(formatted_urls, '\n')

    -- Create a temporary file to hold the content
    local tmp_file = os.tmpname()
    local f = io.open(tmp_file, 'w')
    f:write(uri_list)
    f:close()

    -- Use xclip to copy the content as text/uri-list
    local status, err = Command('sh')
      :arg('-c')
      :arg('cat ' .. tmp_file .. ' | xclip -i -selection clipboard -t text/uri-list')
      :spawn()
      :wait()

    -- Remove the temporary file
    os.remove(tmp_file)

    if status and status.success then
      ya.notify({
        title = 'System Clipboard',
        content = 'Successfully copied the file(s) to system clipboard as URI list',
        level = 'info',
        timeout = 5,
      })
    else
      ya.notify({
        title = 'System Clipboard',
        content = string.format('Could not copy selected file(s) %s', status and status.code or err),
        level = 'error',
        timeout = 5,
      })
    end
  end,
}
