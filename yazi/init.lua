require("git"):setup()
require("no-status"):setup()
require("full-border"):setup { type = ui.Border.ROUNDED, }
require("relative-motions"):setup({ show_numbers="relative_absolute", show_motion = true, enter_mode ="first" })

Header:children_add(function()
	if ya.target_family() ~= "unix" then
		return ""
	end
	return ui.Span(ya.user_name() .. ": "):fg("green")
end, 500, Header.LEFT)

