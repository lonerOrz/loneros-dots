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
