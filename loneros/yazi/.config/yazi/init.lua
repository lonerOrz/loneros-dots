-- init plugins

-- 边框
require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})

-- git 状态提示
require("git"):setup({})
THEME.git = THEME.git or {}
THEME.git.modified = ui.Style():fg("blue")
THEME.git.deleted = ui.Style():fg("red"):bold()
THEME.git.modified_sign = "M"
THEME.git.deleted_sign = "D"
