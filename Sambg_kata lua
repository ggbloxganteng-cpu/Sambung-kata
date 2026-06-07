-- =============================================
-- SAMBUNG KATA PRO v2.0 | Clean UI + KBBI + Compete Mode
-- Dibuat untuk Paramek / GG Edu Style
-- Fitur: Clean UI, Auto Answer KBBI, Compete Mode (rare ending), Human Delay, Database, Log
-- =============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ==================== KBBI DICTIONARY (Sample - Expandable) ====================
local Dictionary = {
    ["a"] = {"air", "api", "apel", "anjing", "ayam", "abdi", "adik", "alamat", "angka", "awan", "asal", "atas", "awal", "ayah", "arloji"},
    ["b"] = {"bola", "buku", "bunga", "baru", "besar", "baik", "belajar", "bermain", "bicara", "binatang", "burung", "bus", "bahan"},
    ["c"] = {"cinta", "cantik", "cepat", "cerdas", "cuaca", "coklat", "cabai", "cacing", "camar", "candi", "cerita"},
    ["d"] = {"danau", "darat", "datang", "dunia", "durian", "dapur", "dinding", "dokter", "domba", "duduk", "darah"},
    ["e"] = {"elang", "emas", "enak", "energi", "es", "ekor", "embun", "enggak", "email"},
    ["g"] = {"gajah", "garam", "garasi", "gelap", "gembira", "gula", "guru", "gunung", "gambar", "gantung"},
    ["h"] = {"hati", "harimau", "hijau", "hitam", "hidup", "harga", "hujan", "huruf", "handuk", "harmoni"},
    ["i"] = {"ikan", "ilmu", "indah", "istana", "ibu", "iman", "ingat", "istri", "itu", "ini"},
    ["k"] = {"kucing", "kuda", "kota", "kecil", "kuat", "kaya", "kantor", "kapal", "kertas", "keyboard", "kamar"},
    ["l"] = {"laut", "langit", "lari", "lelah", "lembut", "lezat", "lilin", "listrik", "lombok", "lupa", "lemari"},
    ["m"] = {"makan", "minum", "mobil", "motor", "muka", "mata", "mulut", "meja", "mandi", "malam", "manis", "masuk"},
    ["n"] = {"nama", "naga", "nasi", "negara", "negeri", "nilai", "nomor", "nenek", "nanti", "nyanyi"},
    ["p"] = {"pintar", "pohon", "pulau", "pantai", "pagar", "pakaian", "panas", "pensil", "perahu", "pesta"},
    ["r"] = {"rumah", "rambut", "roti", "radio", "rakit", "ranjang", "rapat", "rasa", "ratu", "remaja"},
    ["s"] = {"saya", "sambung", "sehat", "sekolah", "senang", "siang", "sore", "suara", "sungai", "surat", "susu", "senyum"},
    ["t"] = {"tangan", "tanah", "tinggi", "terang", "terbang", "tidur", "toko", "tomat", "topi", "tua", "teman"},
    ["u"] = {"udara", "ubi", "ujung", "ulat", "ular", "umur", "unta", "urut", "usaha", "uang"},
    ["w"] = {"warna", "waktu", "wajah", "wangi", "wayang", "wibawa", "wilayah"},
    ["y"] = {"yang", "yoyo", "yodium", "yoga"}
}

-- Build frequency untuk Compete Mode
local letterStartCount = {}
for letter, words in pairs(Dictionary) do
    letterStartCount[letter] = #words
end

-- ==================== VARIABLES ====================
local usedWords = {}
local autoEnabled = false
local competeMode = false
local humanDelay = 2.2
local currentTab = "Beranda"

local gui = Instance.new("ScreenGui")
gui.Name = "SambungKataPro"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = gethui and gethui() or player:WaitForChild("PlayerGui")

-- ==================== CLEAN UI CREATION ====================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 380)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(60, 65, 90)
uiStroke.Thickness = 1.5
uiStroke.Parent = mainFrame

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 42)
topBar.BackgroundColor3 = Color3.fromRGB(15, 17, 28)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

local title = Instance.new("TextLabel")
title.Text = "SAMBUNG KATA PRO  •  KBBI + COMPETE"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(0, 230, 180)
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 15, 0, 8)
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.BackgroundTransparency = 1
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Parent = topBar
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Tab Buttons
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -20, 0, 36)
tabContainer.Position = UDim2.new(0, 10, 0, 50)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

local tabs = {"Beranda", "Auto Play", "Compete", "Database", "Settings"}
local tabButtons = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Text = tabName
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(200, 205, 220)
    btn.BackgroundColor3 = Color3.fromRGB(30, 33, 50)
    btn.Size = UDim2.new(0, 95, 0, 32)
    btn.Position = UDim2.new(0, (i-1) * 100, 0, 0)
    btn.Parent = tabContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
    
    tabButtons[tabName] = btn
end

-- Content Frames
local contentFrames = {}

local function createContentFrame(name)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 1, -100)
    frame.Position = UDim2.new(0, 10, 0, 95)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = mainFrame
    contentFrames[name] = frame
    return frame
end

-- ==================== BERANDA TAB ====================
local beranda = createContentFrame("Beranda")

local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "Status: Idle"
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 18
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
statusLabel.Position = UDim2.new(0, 20, 0, 10)
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Parent = beranda

local currentLetterLabel = Instance.new("TextLabel")
currentLetterLabel.Text = "Huruf Saat Ini: -"
currentLetterLabel.Font = Enum.Font.Gotham
currentLetterLabel.TextSize = 15
currentLetterLabel.TextColor3 = Color3.fromRGB(220, 225, 240)
currentLetterLabel.Position = UDim2.new(0, 20, 0, 45)
currentLetterLabel.Size = UDim2.new(1, -40, 0, 25)
currentLetterLabel.Parent = beranda

local modeLabel = Instance.new("TextLabel")
modeLabel.Text = "Mode: Normal"
modeLabel.Font = Enum.Font.GothamMedium
modeLabel.TextSize = 14
modeLabel.TextColor3 = Color3.fromRGB(180, 190, 210)
modeLabel.Position = UDim2.new(0, 20, 0, 75)
modeLabel.Size = UDim2.new(1, -40, 0, 25)
modeLabel.Parent = beranda

local startBtn = Instance.new("TextButton")
startBtn.Text = "▶ START AUTO ANSWER"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 16
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 130)
startBtn.Size = UDim2.new(0, 220, 0, 45)
startBtn.Position = UDim2.new(0.5, -110, 0, 120)
startBtn.Parent = beranda

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = startBtn

startBtn.MouseButton1Click:Connect(function()
    autoEnabled = not autoEnabled
    if autoEnabled then
        startBtn.Text = "■ STOP AUTO"
        startBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
        statusLabel.Text = "Status: Running..."
        coroutine.resume(coroutine.create(mainLoop))
    else
        startBtn.Text = "▶ START AUTO ANSWER"
        startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 130)
        statusLabel.Text = "Status: Stopped"
    end
end)

-- ==================== AUTO PLAY TAB ====================
local autoPlay = createContentFrame("Auto Play")

local autoToggle = Instance.new("TextButton")
autoToggle.Text = "Auto Answer: OFF"
autoToggle.Font = Enum.Font.GothamBold
autoToggle.TextSize = 15
autoToggle.BackgroundColor3 = Color3.fromRGB(60, 65, 90)
autoToggle.Size = UDim2.new(0, 200, 0, 40)
autoToggle.Position = UDim2.new(0, 20, 0, 15)
autoToggle.Parent = autoPlay

local delayLabel = Instance.new("TextLabel")
delayLabel.Text = "Human Delay: 2.2s"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 14
delayLabel.Position = UDim2.new(0, 20, 0, 70)
delayLabel.Parent = autoPlay

local delayBox = Instance.new("TextBox")
delayBox.Text = "2.2"
delayBox.Font = Enum.Font.Gotham
delayBox.TextSize = 14
delayBox.Size = UDim2.new(0, 80, 0, 30)
delayBox.Position = UDim2.new(0, 180, 0, 65)
delayBox.BackgroundColor3 = Color3.fromRGB(35, 38, 55)
delayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayBox.Parent = autoPlay

delayBox.FocusLost:Connect(function()
    humanDelay = tonumber(delayBox.Text) or 2.2
    delayLabel.Text = "Human Delay: " .. humanDelay .. "s"
end)

-- ==================== COMPETE TAB ====================
local compete = createContentFrame("Compete")

local competeToggle = Instance.new("TextButton")
competeToggle.Text = "Compete Mode: OFF"
competeToggle.Font = Enum.Font.GothamBold
competeToggle.TextSize = 15
competeToggle.BackgroundColor3 = Color3.fromRGB(180, 80, 200)
competeToggle.Size = UDim2.new(0, 220, 0, 42)
competeToggle.Position = UDim2.new(0, 20, 0, 15)
competeToggle.Parent = compete

local competeDesc = Instance.new("TextLabel")
competeDesc.Text = "Compete Mode akan memilih kata yang berakhiran huruf JARANG (sulit dilanjutkan lawan). Cocok buat menang kompetitif!"
competeDesc.Font = Enum.Font.Gotham
competeDesc.TextSize = 12
competeDesc.TextWrapped = true
competeDesc.TextColor3 = Color3.fromRGB(200, 200, 220)
competeDesc.Position = UDim2.new(0, 20, 0, 70)
competeDesc.Size = UDim2.new(1, -40, 0, 60)
competeDesc.Parent = compete

local rareLabel = Instance.new("TextLabel")
rareLabel.Text = "Huruf Jarang (otomatis diprioritaskan): x, q, z, f, v, j"
rareLabel.Font = Enum.Font.GothamMedium
rareLabel.TextSize = 12
rareLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
rareLabel.Position = UDim2.new(0, 20, 0, 140)
rareLabel.Parent = compete

-- ==================== DATABASE TAB ====================
local database = createContentFrame("Database")

local searchBox = Instance.new("TextBox")
searchBox.PlaceholderText = "Cari kata (contoh: rumah)..."
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
searchBox.Size = UDim2.new(1, -40, 0, 35)
searchBox.Position = UDim2.new(0, 20, 0, 10)
searchBox.BackgroundColor3 = Color3.fromRGB(35, 38, 55)
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.Parent = database

local resultFrame = Instance.new("ScrollingFrame")
resultFrame.Size = UDim2.new(1, -40, 0, 200)
resultFrame.Position = UDim2.new(0, 20, 0, 55)
resultFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 42)
resultFrame.BorderSizePixel = 0
resultFrame.ScrollBarThickness = 6
resultFrame.Parent = database

local resultLayout = Instance.new("UIListLayout")
resultLayout.Padding = UDim.new(0, 4)
resultLayout.Parent = resultFrame

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    -- Simple search (bisa diimprove)
    for _, child in pairs(resultFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local query = searchBox.Text:lower()
    if #query < 2 then return end
    
    for letter, words in pairs(Dictionary) do
        for _, word in ipairs(words) do
            if word:lower():find(query) then
                local btn = Instance.new("TextButton")
                btn.Text = word .. "  (" .. letter:upper() .. ")"
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 13
                btn.Size = UDim2.new(1, 0, 0, 28)
                btn.BackgroundColor3 = Color3.fromRGB(40, 43, 60)
                btn.TextColor3 = Color3.fromRGB(220, 225, 240)
                btn.Parent = resultFrame
                
                btn.MouseButton1Click:Connect(function()
                    -- Auto submit jika mau
                    submitWord(word)
                end)
            end
        end
    end
end)

-- ==================== SETTINGS TAB ====================
local settings = createContentFrame("Settings")

local resetBtn = Instance.new("TextButton")
resetBtn.Text = "🔄 Reset Used Words"
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 14
resetBtn.BackgroundColor3 = Color3.fromRGB(70, 90, 130)
resetBtn.Size = UDim2.new(0, 200, 0, 38)
resetBtn.Position = UDim2.new(0, 20, 0, 15)
resetBtn.Parent = settings

resetBtn.MouseButton1Click:Connect(function()
    usedWords = {}
    statusLabel.Text = "Used words cleared!"
end)

local infoLabel = Instance.new("TextLabel")
infoLabel.Text = "Script by Grok • KBBI Sample v2\nExpand dictionary untuk performa lebih baik\nCompete Mode = pilih ending huruf langka"
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 12
infoLabel.TextColor3 = Color3.fromRGB(160, 165, 185)
infoLabel.Position = UDim2.new(0, 20, 0, 70)
infoLabel.Size = UDim2.new(1, -40, 0, 80)
infoLabel.Parent = settings

-- ==================== TAB SWITCHING ====================
function switchTab(tabName)
    for name, frame in pairs(contentFrames) do
        frame.Visible = (name == tabName)
    end
    for name, btn in pairs(tabButtons) do
        if name == tabName then
            btn.BackgroundColor3 = Color3.fromRGB(0, 180, 140)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(30, 33, 50)
            btn.TextColor3 = Color3.fromRGB(200, 205, 220)
        end
    end
    currentTab = tabName
end

switchTab("Beranda")

-- ==================== CORE FUNCTIONS ====================
local function getCurrentStartLetter()
    local gui = player:WaitForChild("PlayerGui")
    for _, descendant in ipairs(gui:GetDescendants()) do
        if (descendant:IsA("TextLabel") or descendant:IsA("TextButton")) and descendant.Text \~= "" then
            local text = descendant.Text:lower()
            -- Pattern umum di game Sambung Kata
            if text:find("huruf terakhir") or text:find("lanjutkan dengan") or text:find("kata terakhir") then
                local match = text:match("huruf%s*([a-z])") or text:match("dengan%s*([a-z])") or text:match("terakhir:%s*([%w])")
                if match then return match:upper() end
            end
            -- Jika menampilkan kata terakhir
            if text:match("^%a+$") and #text >= 3 then
                return text:sub(-1):upper()
            end
        end
    end
    return nil
end

local function findGameInput()
    local pgui = player:WaitForChild("PlayerGui")
    for _, v in ipairs(pgui:GetDescendants()) do
        if v:IsA("TextBox") and v.Visible then
            local n = v.Name:lower()
            local p = v.PlaceholderText:lower()
            if n:find("input") or n:find("chat") or n:find("answer") or p:find("kata") or p:find("ketik") then
                return v
            end
        end
    end
    return nil
end

local function submitWord(word)
    local input = findGameInput()
    if input then
        input.Text = word
        wait(0.08)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        usedWords[word:lower()] = true
        statusLabel.Text = "Submitted: " .. word
    else
        warn("[SambungKataPro] Input box tidak ditemukan! Update finder di script.")
    end
end

local function getBestCompeteWord(startLetter)
    local candidates = Dictionary[startLetter:lower()] or {}
    if #candidates == 0 then return nil end
    
    local bestWord = nil
    local bestScore = -1
    
    for _, word in ipairs(candidates) do
        if usedWords[word:lower()] then continue end
        
        local endLetter = word:sub(-1):lower()
        local freq = letterStartCount[endLetter] or 1
        local score = 120 / freq   -- semakin jarang, semakin tinggi score
        
        -- Bonus untuk huruf super langka
        if endLetter == "x" or endLetter == "q" or endLetter == "z" or endLetter == "f" or endLetter == "v" then
            score = score * 2.5
        end
        
        if score > bestScore then
            bestScore = score
            bestWord = word
        end
    end
    
    return bestWord or candidates[math.random(1, #candidates)]
end

-- ==================== MAIN LOOP ====================
function mainLoop()
    while autoEnabled do
        local letter = getCurrentStartLetter()
        if letter then
            currentLetterLabel.Text = "Huruf Saat Ini: " .. letter
            
            local word
            if competeMode then
                word = getBestCompeteWord(letter)
                modeLabel.Text = "Mode: COMPETE (Hard)"
            else
                local cands = Dictionary[letter:lower()] or {}
                for _, w in ipairs(cands) do
                    if not usedWords[w:lower()] then
                        word = w
                        break
                    end
                end
                modeLabel.Text = "Mode: Normal"
            end
            
            if word then
                wait(humanDelay + math.random(-0.4, 0.6))
                submitWord(word)
            else
                statusLabel.Text = "Tidak ada kata untuk huruf " .. letter
            end
        end
        wait(0.6)
    end
end

-- Toggle compete
competeToggle.MouseButton1Click:Connect(function()
    competeMode = not competeMode
    if competeMode then
        competeToggle.Text = "Compete Mode: ON 🔥"
        competeToggle.BackgroundColor3 = Color3.fromRGB(220, 60, 180)
    else
        competeToggle.Text = "Compete Mode: OFF"
        competeToggle.BackgroundColor3 = Color3.fromRGB(180, 80, 200)
    end
end)

autoToggle.MouseButton1Click:Connect(function()
    autoEnabled = not autoEnabled
    if autoEnabled then
        autoToggle.Text = "Auto Answer: ON"
        autoToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 130)
        coroutine.resume(coroutine.create(mainLoop))
    else
        autoToggle.Text = "Auto Answer: OFF"
        autoToggle.BackgroundColor3 = Color3.fromRGB(60, 65, 90)
    end
end)

-- ==================== INIT ====================
print("[SambungKataPro] Script loaded! GUI muncul di tengah layar.")
statusLabel.Text = "Ready • Join game & tekan START"
switchTab("Beranda")

-- Optional: Auto refresh current letter setiap 1.5 detik di Beranda
RunService.Heartbeat:Connect(function()
    if currentTab == "Beranda" and not autoEnabled then
        local l = getCurrentStartLetter()
        if l then currentLetterLabel.Text = "Huruf Saat Ini: " .. l end
    end
end)
