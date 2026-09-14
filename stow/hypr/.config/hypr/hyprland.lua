-- =============================================================================
-- hyprland.lua · NyxNiri 整套 niri 配置的 Hyprland 移植版
-- 来源: ~/.config/niri/*.kdl  (2026-09-01 翻译)
-- 说明: 存在 hyprland.lua 时 Hyprland 优先加载本文件, 旧 hyprland.conf 不再生效。
-- =============================================================================

local mod  = "SUPER"
local home = os.getenv("HOME")

-- ---------------------------------------------------------------------------
-- 环境变量 (niri: config.kdl -> environment)
-- ---------------------------------------------------------------------------
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GTK_IM_MODULE", "")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Adwaita")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("HTTP_PROXY", "http://127.0.0.1:7890")
hl.env("HTTPS_PROXY", "http://127.0.0.1:7890")
hl.env("ALL_PROXY", "http://127.0.0.1:7890")
hl.env("http_proxy", "http://127.0.0.1:7890")
hl.env("https_proxy", "http://127.0.0.1:7890")
hl.env("all_proxy", "http://127.0.0.1:7890")
hl.env("NO_PROXY", "localhost,127.0.0.1,::1,api.noctalia.dev")
hl.env("no_proxy", "localhost,127.0.0.1,::1,api.noctalia.dev")

-- NVIDIA 环境变量(如有 N 卡再取消注释)
-- hl.env("GBM_BACKEND", "nvidia-drm")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- hl.env("LIBVA_DRIVER_NAME", "nvidia")

-- ---------------------------------------------------------------------------
-- 显示器 (niri: monitor.kdl)
-- ---------------------------------------------------------------------------
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- ---------------------------------------------------------------------------
-- Noctalia 配色 (niri: noctalia.kdl)
-- ---------------------------------------------------------------------------
local noctalia = {
    primary         = "rgb(8bc1bf)",
    surface         = "rgb(1a2323)",
    secondary       = "rgb(819cb1)",
    error           = "rgb(fd4663)",
    tertiary        = "rgb(8586ad)",
    surface_lowest  = "rgb(0d1111)",
}

-- ---------------------------------------------------------------------------
-- 外观 / 布局 / 输入 (niri: layout.kdl + noctalia.kdl + input__custom__.kdl)
-- ---------------------------------------------------------------------------
hl.config({
    general = {
        gaps_in        = 12,
        gaps_out       = 12,
        border_size    = 1,
        col = {
            active_border   = noctalia.primary,
            inactive_border = noctalia.surface,
        },
        layout = "scrolling",
    },

    decoration = {
        rounding           = 12,
        active_opacity     = 0.9,   -- niri effects_normal.kdl: 聚焦 0.9
        inactive_opacity   = 0.85,  -- niri effects_normal.kdl: 失焦 0.85
        fullscreen_opacity = 1.0,
        shadow = {
            enabled      = true,
            range        = 14,      -- niri softness 10 + spread 4
            render_power = 3,
            color        = 0x00000070,
            offset       = { 0, 0 },
        },
        blur = {
            enabled           = true,
            size              = 3,  -- niri passes 3 / offset 2.3 的近似
            passes            = 3,
            vibrancy          = 0.5, -- niri saturation 2 的近似
            noise             = 0.001,
            contrast          = 1.0,
            brightness        = 1.0,
            xray              = false,
            ignore_opacity    = true,
            new_optimizations = true,
        },
    },

    animations = {
        enabled = true,
    },

    input = {
        kb_options     = "ctrl:nocaps",
        numlock_by_default = true,
        sensitivity    = 0,      -- 全局保持默认; niri 的鼠标 accel 见下方 hl.device
        follow_mouse   = 1,
        touchpad = {
            natural_scroll       = true,
            tap_to_click         = true,
            disable_while_typing = true,
        },
    },

    group = {
        -- niri 的列不会自动合并, 这里关闭自动入组, 仅按需 Mod+G 成组
        auto_group = false,
        col = {
            border_active          = noctalia.primary,
            border_inactive        = noctalia.secondary,
            border_locked_active   = noctalia.error,
            border_locked_inactive = noctalia.tertiary,
        },
        groupbar = {
            enabled = true,
            col = {
                active          = noctalia.primary,
                inactive        = "rgb(2f6a68)",
                locked_active   = noctalia.error,
                locked_inactive = noctalia.tertiary,
            },
        },
    },

    -- Scrolling 布局: niri 式滚动平铺
    scrolling = {
        column_width            = 0.5,
        fullscreen_on_one_column = true,   -- 单列时铺满整屏 (≈ niri always-center-single-column)
        direction               = "right",
        wrap_focus              = true,
        wrap_swapcol            = true,
        explicit_column_widths  = "0.333, 0.5, 0.667, 1.0",  -- niri preset-column-widths
    },

    binds = {
        scroll_event_delay = 150,  -- niri 滚轮切工作区 150ms 冷却
    },

    misc = {
        force_default_wallpaper = 0,  -- 壁纸交给 noctalia 管理
        disable_hyprland_logo   = true,
        close_special_on_empty  = true,
    },

    ecosystem = {
        no_update_news  = true,
        no_donation_nag = true,
    },
})

-- ---------------------------------------------------------------------------
-- 指针设备 (niri: input__custom__.kdl 只对 mouse 设置 accel-speed -0.72)
-- 触控板保持默认速度; 如果设备名不一致, 登录 Hyprland 后执行
-- hyprctl devices -j 查看实际名称
-- ---------------------------------------------------------------------------
hl.device({
    name        = "UNIW0001:00 093A:0255 Mouse",
    sensitivity = -0.72,
})
hl.device({
    name        = "UNIW0001:00 093A:0255 Touchpad",
    sensitivity = 0,
})

-- ---------------------------------------------------------------------------
-- 动画 (niri: animations.kdl, 弹簧参数按 mass=1 换算 dampening)
-- ---------------------------------------------------------------------------
hl.curve("nyxWs",     { type = "spring", mass = 1, stiffness = 523, dampening = 36.6 })  -- workspace-switch
hl.curve("nyxMove",   { type = "spring", mass = 1, stiffness = 323, dampening = 27.0 })  -- window-movement
hl.curve("nyxResize", { type = "spring", mass = 1, stiffness = 423, dampening = 35.0 })  -- window-resize
hl.curve("nyxOverview", { type = "spring", mass = 1, stiffness = 800, dampening = 48.0 }) -- overview-open-close
hl.curve("nyxEaseOutExpo", { type = "bezier", points = { {0.16, 1}, {0.3, 1} } })
hl.curve("nyxEaseOutQuad", { type = "bezier", points = { {0.25, 0.46}, {0.45, 0.94} } })

hl.animation({ leaf = "global",       enabled = true, speed = 10,  bezier = "nyxEaseOutQuad" })
hl.animation({ leaf = "workspaces",   enabled = true, speed = 6,   spring = "nyxWs",     style = "slidefade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 6,   spring = "nyxWs",     style = "slidefade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 6,  spring = "nyxWs",     style = "slidefade" })
hl.animation({ leaf = "specialWorkspace",   enabled = true, speed = 6, spring = "nyxWs", style = "slidefade" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 6, spring = "nyxWs", style = "slidefade" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 6, spring = "nyxWs", style = "slidefade" })
hl.animation({ leaf = "windows",      enabled = true, speed = 5,   spring = "nyxMove",   style = "popin 80%" })
hl.animation({ leaf = "windowsIn",    enabled = true, speed = 1.5, bezier = "nyxEaseOutExpo", style = "popin 80%" })
hl.animation({ leaf = "windowsOut",   enabled = true, speed = 1.5, bezier = "nyxEaseOutQuad", style = "popin 80%" })
hl.animation({ leaf = "windowsMove",  enabled = true, speed = 5,   spring = "nyxMove" })
hl.animation({ leaf = "fade",         enabled = true, speed = 2,   bezier = "nyxEaseOutQuad" })
hl.animation({ leaf = "fadeIn",       enabled = true, speed = 2,   bezier = "nyxEaseOutQuad" })
hl.animation({ leaf = "fadeOut",      enabled = true, speed = 2,   bezier = "nyxEaseOutQuad" })
hl.animation({ leaf = "border",       enabled = true, speed = 5.4, bezier = "nyxEaseOutQuad" })
hl.animation({ leaf = "layers",       enabled = true, speed = 3.8, bezier = "nyxEaseOutQuad", style = "fade" })
hl.animation({ leaf = "layersIn",     enabled = true, speed = 3.8, bezier = "nyxEaseOutQuad", style = "fade" })
hl.animation({ leaf = "layersOut",    enabled = true, speed = 3.8, bezier = "nyxEaseOutQuad", style = "fade" })

-- ---------------------------------------------------------------------------
-- 图层规则 (niri: rules.kdl -> layer-rule)
-- ---------------------------------------------------------------------------
hl.layer_rule({ match = { namespace = "^noctalia-wallpaper.*" }, no_anim = true })
hl.layer_rule({ match = { namespace = "^mpvpaper$" }, no_anim = true })
hl.layer_rule({
    match   = { namespace = "noctalia-bar-bar" },
    blur    = false,
    no_anim = true,
})

-- ---------------------------------------------------------------------------
-- 窗口规则 (niri: rules.kdl + effects*.kdl + layout.kdl)
-- ---------------------------------------------------------------------------
-- 通用: 圆角 12 + 去背景边框 (对应 layout.kdl 的全局窗口规则)
-- Hyprland 用 decoration.rounding 全局生效, 个别窗口用 rounding 覆盖

hl.window_rule({ match = { class = "^dev\\.noctalia\\.Noctalia$" }, float = true })

-- niri 的 default-column-width 对应 scrolling_width
hl.window_rule({ match = { class = "^org\\.wezfurlong\\.wezterm$" }, scrolling_width = 0.5 })
hl.window_rule({
    match = { class = "^gnome-control-center$|^pavucontrol$|^nm-connection-editor$" },
    scrolling_width = 0.5,
})

hl.window_rule({
    match = { class = "^org\\.gnome\\.Calculator$|^gnome-calculator$|^galculator$|^blueman-manager$|^org\\.gnome\\.Nautilus$|^xdg-desktop-portal$" },
    float = true,
})

-- Steam 通知 toast: 右下角浮动, 不抢焦点
hl.window_rule({
    match            = { class = "^steam$", title = "^notificationtoasts_\\d+_desktop$" },
    float            = true,
    no_initial_focus = true,
    move             = "(monitor_w-10-window_w) (monitor_h-10-window_h)",
})

hl.window_rule({ match = { class = "^zoom$" }, float = true })

hl.window_rule({
    match = { class = "^wine$" },
    float = true,
    size  = "(monitor_w) (monitor_h)",
    center = true,
})

-- Wine / Proton 托盘占位窗口: 透明 + 移出屏幕 + 不抢焦点
hl.window_rule({
    match            = { class = "^[Ee]xplorer\\.exe$", title = "^$" },
    float            = true,
    no_initial_focus = true,
    opacity          = "0 override",
    move             = "-9999 -9999",
    no_shadow        = true,
    no_blur          = true,
    no_anim          = true,
})
hl.window_rule({
    match            = { class = "^[Ee]xplorer\\.exe$", title = "^Wine System Tray$" },
    float            = true,
    no_initial_focus = true,
    opacity          = "0 override",
    move             = "-9999 -9999",
    no_shadow        = true,
    no_blur          = true,
    no_anim          = true,
})
hl.window_rule({
    match            = { class = "^[Ee]xplorer\\.exe$", title = "^Wine$" },
    float            = true,
    no_initial_focus = true,
    opacity          = "0 override",
    move             = "-9999 -9999",
    no_shadow        = true,
    no_blur          = true,
    no_anim          = true,
})
hl.window_rule({
    match            = { class = "^(wineboot|services)\\.exe$" },
    float            = true,
    no_initial_focus = true,
    opacity          = "0 override",
    move             = "-9999 -9999",
    no_shadow        = true,
    no_blur          = true,
    no_anim          = true,
})
hl.window_rule({
    match            = { title = "^Wine System Tray$" },
    float            = true,
    no_initial_focus = true,
    opacity          = "0 override",
    move             = "-9999 -9999",
    no_shadow        = true,
    no_blur          = true,
    no_anim          = true,
})

-- 半透明 + 毛玻璃应用 (niri rules.kdl 的 glassy 规则)
hl.window_rule({ match = { class = "^org\\.pwmt\\.zathura$" }, opacity = "0.8 override" })
hl.window_rule({ match = { class = "^codium$" },              opacity = "0.85 override" })
hl.window_rule({ match = { class = "^steam$" },               opacity = "0.9 override" })
hl.window_rule({ match = { class = "^obsidian$" },            opacity = "0.9 override" })

-- Zen 浏览器 / Nautilus: 无背景边框 + 毛玻璃
hl.window_rule({ match = { class = "^app\\.zen_browser\\.zen$" }, border_size = 0 })
hl.window_rule({ match = { class = "^org\\.gnome\\.Nautilus$" }, border_size = 0 })

-- 游戏: 无特效最高性能
hl.window_rule({
    match = { class = "^steam_app_.*$" },
    opacity = "1 override",
    no_blur = true,
    no_shadow = true,
    no_anim = true,
})
hl.window_rule({
    match = { class = "^gamescope$" },
    opacity = "1 override",
    no_blur = true,
    no_shadow = true,
    no_anim = true,
})
hl.window_rule({
    match = { title = "^(?i:genshin impact|zenless zone zero|victoria 3|Minecraft|Endfield)$" },
    opacity = "1 override",
    no_blur = true,
    no_shadow = true,
    no_anim = true,
})

-- 画中画: 全工作区悬浮, 右下角
hl.window_rule({
    match = { title = "(?:画中画|Picture-in-Picture)" },
    float = true,
    opacity = "1 override",
    move  = "(monitor_w-20-window_w) (monitor_h-20-window_h)",
})

-- 视频软件: 不透明
hl.window_rule({
    match = { class = "^org\\.kde\\.kdenlive$|^mpv$|^kazumi$|^celluloid$|^virt-manager$" },
    opacity = "1 override",
})

-- 图片/视频查看器: 浮动 + 不透明
hl.window_rule({
    match = { title = "(?:图片查看器|Image Viewer|图片和视频|Image and Video Viewer|视频播放器|Video Player|Videos)" },
    float = true,
    opacity = "1 override",
})
hl.window_rule({ match = { class = "^org\\.gnome\\.Loupe$|^org\\.gnome\\.Totem$|^org\\.gnome\\.Photos$" }, float = true, opacity = "1 override" })

-- Steam 好友列表: 窄列 (niri default-column-width 0.2)
hl.window_rule({
    match = { class = "^steam$", title = "^Friends List$|^好友列表$" },
    scrolling_width = 0.2,
})

-- QQ 资料卡 / 天气: 不抢焦点; 聊天记录: 浮动
hl.window_rule({ match = { class = "^QQ$", title = "^资料卡$" }, no_initial_focus = true })
hl.window_rule({ match = { class = "^QQ$", title = "^天气$" }, no_initial_focus = true })
hl.window_rule({ match = { class = "^QQ$", title = "^群聊的聊天记录$" }, float = true })

-- imv
hl.window_rule({ match = { class = "^imv$" }, float = true })

-- Ente Auth
hl.window_rule({ match = { class = "^io\\.ente\\.auth$" }, float = true, size = "532 925", center = true })

-- Mission Center
hl.window_rule({
    match  = { class = "^io\\.missioncenter\\.MissionCenter$" },
    float  = true,
    size   = "(monitor_w*0.65) (monitor_h*0.70)",
    center = true,
})

-- Scratchpad 终端 (Super+~)
hl.window_rule({
    match     = { class = "^scratchpad$" },
    float     = true,
    workspace = "special:scratchpad silent",
    size      = "(monitor_w*0.5) (monitor_h*0.45)",
    move      = "(monitor_w*0.5)-(window_w*0.5) 40",
})

-- ---------------------------------------------------------------------------
-- 自启动 (niri: config.kdl -> spawn-at-startup)
-- ---------------------------------------------------------------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("noctalia")
    hl.exec_cmd(home .. "/.config/hypr/scripts/toggle-eyecare.sh --sync")
    hl.exec_cmd("bash -c 'sleep 8; noctalia msg config-reload && noctalia msg templates-apply'")
end)

-- ---------------------------------------------------------------------------
-- 键位 (niri: binds.kdl)
-- ---------------------------------------------------------------------------
local eyecare = home .. "/.config/hypr/scripts/toggle-eyecare.sh"
local scratch = home .. "/.config/hypr/scripts/hypr-scratch-toggle.sh"
local shot    = home .. "/.config/hypr/scripts/hypr-shot.sh"
local orbit   = home .. "/.config/niri/scripts/orbit-launcher.py"

-- 1. 会话与系统
-- niri 的 Mod+Tab 是 overview, Hyprland 需要 overview 插件, 暂不绑定
hl.bind(mod .. " + Q",       hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + Q", function()
    if os.execute("command -v hyprshutdown >/dev/null 2>&1") == 0 then
        hl.dispatch(hl.dsp.exec_cmd("hyprshutdown"))
    else
        hl.dispatch(hl.dsp.exit())
    end
end)
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mod .. " + L",         hl.dsp.exec_cmd("noctalia msg session lock"))
-- niri 的 Mod+/ 快捷键提示覆盖层, Hyprland 暂无内置, 需要时可用 hyprland-binds 之类替代

-- 2. 应用启动
hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + E",      hl.dsp.exec_cmd("nautilus"))
hl.bind(mod .. " + R",      hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind(mod .. " + X",      hl.dsp.exec_cmd("noctalia msg panel-toggle session"))
hl.bind(mod .. " + I",      hl.dsp.exec_cmd("noctalia msg settings-toggle"))
hl.bind(mod .. " + V",      hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
hl.bind(mod .. " + W",      hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper"))
hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd("noctalia msg panel-toggle noctalia/mpvpaper:picker"))
hl.bind(mod .. " + CTRL + W",  hl.dsp.exec_cmd("noctalia msg wallpaper-random"))
hl.bind(mod .. " + N",      hl.dsp.exec_cmd(eyecare))
hl.bind(mod .. " + GRAVE",  hl.dsp.exec_cmd(scratch .. " kitty"))
hl.bind(mod .. " + A",      hl.dsp.exec_cmd(orbit))
hl.bind(mod .. " + mouse:276", hl.dsp.exec_cmd(orbit))

-- 3. 焦点与窗口移动
hl.bind(mod .. " + LEFT",  hl.dsp.layout("focus l"))
hl.bind(mod .. " + RIGHT", hl.dsp.layout("focus r"))
hl.bind(mod .. " + DOWN",  hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + UP",    hl.dsp.focus({ direction = "up" }))

-- 列焦点 (scrolling 布局)
hl.bind(mod .. " + Z", hl.dsp.layout("focus l"))
hl.bind(mod .. " + C", hl.dsp.layout("focus r"))

-- 列搬运: 与相邻列交换
hl.bind(mod .. " + CTRL + LEFT",  hl.dsp.layout("swapcol l"))
hl.bind(mod .. " + CTRL + RIGHT", hl.dsp.layout("swapcol r"))
hl.bind(mod .. " + CTRL + DOWN",  hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + CTRL + UP",    hl.dsp.window.move({ direction = "up" }))

-- niri 的 Shift+方向键=列内精准移动
hl.bind(mod .. " + SHIFT + LEFT",  hl.dsp.layout("swapcol l"))
hl.bind(mod .. " + SHIFT + RIGHT", hl.dsp.layout("swapcol r"))
hl.bind(mod .. " + SHIFT + DOWN",  hl.dsp.window.swap({ direction = "down" }))
hl.bind(mod .. " + SHIFT + UP",    hl.dsp.window.swap({ direction = "up" }))

-- 工作区导航 (niri Mod+D=下/下一个, Mod+U=上/上一个)
hl.bind(mod .. " + D", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + U", hl.dsp.focus({ workspace = "e-1" }))

-- 跨显示器移动
hl.bind(mod .. " + SHIFT + CTRL + LEFT",  hl.dsp.window.move({ monitor = "left" }))
hl.bind(mod .. " + SHIFT + CTRL + RIGHT", hl.dsp.window.move({ monitor = "right" }))
hl.bind(mod .. " + SHIFT + CTRL + DOWN",  hl.dsp.window.move({ monitor = "down" }))
hl.bind(mod .. " + SHIFT + CTRL + UP",    hl.dsp.window.move({ monitor = "up" }))

-- 4. 窗口布局
hl.bind(mod .. " + T",        hl.dsp.window.float({ action = "toggle" }))
-- niri Mod+Shift+T 切换平铺/浮动焦点, Hyprland 无直接等价, 用 cycle_next 近似
hl.bind(mod .. " + SHIFT + T", hl.dsp.window.cycle_next({ next = true }))
hl.bind(mod .. " + G",        hl.dsp.group.toggle())
hl.bind(mod .. " + F",        hl.dsp.layout("colresize 1"))  -- ≈ maximize-column
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- 列宽: 对应 niri 的 preset-column-widths 和 ±5% 微调
hl.bind(mod .. " + SPACE", hl.dsp.layout("colresize +conf"))
hl.bind(mod .. " + MINUS", hl.dsp.layout("colresize -0.05"))
hl.bind(mod .. " + EQUAL", hl.dsp.layout("colresize +0.05"))
-- niri Mod+Shift+Equal = reset-window-height, scrolling 布局无对应, 暂不绑定

-- 组 (tabbed) 操作近似 niri 的 consume/expel
hl.bind(mod .. " + COMMA",  hl.dsp.window.move({ into_or_create_group = "l" }))
hl.bind(mod .. " + PERIOD", hl.dsp.window.move({ out_of_group = true }))

-- 5. 工作区 1-9
for i = 1, 9 do
    hl.bind(mod .. " + " .. i,             hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. i,     hl.dsp.window.move({ workspace = i }))
end

-- 6. 鼠标与滚轮
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + CTRL + mouse_down", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mod .. " + CTRL + mouse_up",   hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mod .. " + mouse_right", hl.dsp.window.cycle_next({ next = true }))
hl.bind(mod .. " + mouse_left",  hl.dsp.window.cycle_next({ next = false }))
hl.bind(mod .. " + SHIFT + mouse_down", hl.dsp.window.cycle_next({ next = true }))
hl.bind(mod .. " + SHIFT + mouse_up",   hl.dsp.window.cycle_next({ next = false }))

-- 7. 多媒体与硬件
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),  { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("sh -c 'ddcutil setvcp 10 + 10'"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("sh -c 'ddcutil setvcp 10 - 10'"), { locked = true, repeating = true })

-- 8. 截图
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd(shot .. " region"))
hl.bind("PRINT",               hl.dsp.exec_cmd(shot .. " region"))
hl.bind("CTRL + PRINT",        hl.dsp.exec_cmd(shot .. " screen"))
hl.bind("ALT + PRINT",         hl.dsp.exec_cmd(shot .. " window"))

-- 9. 最近窗口 (niri recent-windows binds)
hl.bind("ALT + TAB", function()
    hl.dispatch(hl.dsp.window.cycle_next({ next = true }))
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)
hl.bind("ALT + SHIFT + TAB", function()
    hl.dispatch(hl.dsp.window.cycle_next({ next = false }))
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)
hl.bind("ALT + GRAVE", function()
    hl.dispatch(hl.dsp.window.cycle_next({ next = true }))
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)
hl.bind("ALT + SHIFT + GRAVE", function()
    hl.dispatch(hl.dsp.window.cycle_next({ next = false }))
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)

-- 拖拽/缩放窗口
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- For Noctalia Color templates
require("noctalia").apply_theme()
