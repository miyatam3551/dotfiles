-- 英数入力のID(あなたの環境に合わせて変更)
local inputSourceEnglish = "com.apple.keylayout.ABC"

-- アプリケーションフォーカス監視
local appWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
    if eventType == hs.application.watcher.activated then
        -- WezTerm または Obsidian フォーカス時に英数に変更
        if appName == "WezTerm" or appName == "Obsidian" then
            hs.execute("/opt/homebrew/bin/im-select " .. inputSourceEnglish)
        end
    end
end)
appWatcher:start()

-- F15 を Command + Space にマッピングする
hs.hotkey.bind({}, "F15", function()
  hs.eventtap.keyStroke({"cmd"}, "space", 0)
end)

