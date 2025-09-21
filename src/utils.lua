function log(txt, clear)
    if clear == nil then clear = false end
    printh(txt, "/logs/log", clear)
end

--center print
function cprnt(txt, y, clr)
    local clr = clr or 7
    local y = y or 64

    print(txt, 64 - #txt * 2, y, 7)
end