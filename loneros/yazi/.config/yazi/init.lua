-- init plugins

-- 边框
require("full-border"):setup({
  -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
  type = ui.Border.ROUNDED,
})

-- git 状态提示
require("git"):setup()
th.git = th.git or {}
th.git.modified = ui.Style():fg("blue")
th.git.deleted = ui.Style():fg("red"):bold()
th.git.modified_sign = "M"
th.git.deleted_sign = "D"

-- 在状态栏中显示符号链接
Status:children_add(function(self)
  local h = self._current.hovered
  if h and h.link_to then
    return " -> " .. tostring(h.link_to)
  else
    return ""
  end
end, 3300, Status.LEFT)
