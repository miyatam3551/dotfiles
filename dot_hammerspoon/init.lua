-- #########################################################################
-- アプリケーションフォーカス時に入力ソースを切り替える
-- #########################################################################

-- 英数入力のID(あなたの環境に合わせて変更)
local inputSourceEnglish = "com.apple.keylayout.ABC"

-- アプリケーションフォーカス監視
local appWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
    if eventType == hs.application.watcher.activated then
        --  指定アプリへのフォーカス時に英数に変更
        if appName == "Ghostty" or appName == "Obsidian" then
            hs.execute("/opt/homebrew/bin/im-select " .. inputSourceEnglish)
        end
    end
end)
appWatcher:start()

-- #########################################################################
-- F15 キーを Command + Space にマッピング
-- #########################################################################

-- F15 を Command + Space にマッピングする
hs.hotkey.bind({}, "F15", function()
  hs.eventtap.keyStroke({"cmd"}, "space", 0)
end)

-- #########################################################################
-- アプリケーション切り替えショートカット
-- #########################################################################

-- Hyper key の定義
local hyper = {"ctrl", "shift", "alt", "cmd"}

-- アプリにフォーカス（なければ起動）
local function focusApp(appName)
    local app = hs.application.find(appName)
    if app then
        app:activate()
    else
        hs.application.launchOrFocus(appName)
    end
end

-- キーバインド
hs.hotkey.bind(hyper, "a", function() focusApp("Arc") end)
hs.hotkey.bind(hyper, "b", function() focusApp("Kindle") end)
hs.hotkey.bind(hyper, "c", function() focusApp("Claude") end)
hs.hotkey.bind(hyper, "f", function() focusApp("Ghostty") end)
hs.hotkey.bind(hyper, "g", function() focusApp("chatGPT Atlas") end)
hs.hotkey.bind(hyper, "o", function() focusApp("Obsidian") end)
hs.hotkey.bind(hyper, "s", function()
    local app = hs.application.find("Slack")
    if app then
        app:activate()
        hs.timer.doAfter(0.1, function()
            -- Slack ですべての未読メッセージに移動
            hs.eventtap.keyStroke({"cmd", "shift"}, "a")
        end)
    else
        hs.application.launchOrFocus("Slack")
    end
end)
