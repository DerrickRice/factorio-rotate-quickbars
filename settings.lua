-- settings
data:extend({
    {
        name = "dr_quickbar_which_bars",
        type = "string-setting",
        setting_type = "runtime-per-user",
        default_value = "1,2",
        allow_blank = false,
        order = "001"
    },
    {
        name = "dr_quickbar_range",
        type = "string-setting",
        setting_type = "runtime-per-user",
        default_value = "1-10",
        allow_blank = false,
        order = "002"
    },
    {
        name = "dr_quickbar_stepsize",
        type = "string-setting",
        setting_type = "runtime-per-user",
        default_value = "1",
        allow_blank = false,
        order = "003"
    }
})
