------------------------------------------------------------------------------
-- Modify from https://github.com/nodemcu/nodemcu-firmware/blob/master/lua_examples/lfs/dummy_strings.lua
-- Put all string(except preload_ignore) found in printRam(),
-- and add this lua script when creating LFS image, to reduce ram usage.
------------------------------------------------------------------------------

local preload = "?.lc;?.lua", "/\n;\n?\n!\n-", "@init.lua", "_G", "_LOADED",
"_LOADLIB", "__add", "__call", "__concat", "__div", "__eq", "__gc", "__index",
"__le", "__len", "__lt", "__mod", "__mode", "__mul", "__newindex", "__pow",
"__sub", "__tostring", "__unm", "collectgarbage", "cpath", "debug", "file",
"file.obj", "file.vol", "flash", "getstrings", "index", "ipairs", "list", "loaded",
"loader", "loaders", "loadlib", "module", "net.tcpserver", "net.tcpsocket",
"net.udpsocket", "newproxy", "package", "pairs", "path", "preload", "reload",
"require", "seeall", "wdclr", "not enough memory", "sjson.decoder", "sjson.encoder",
"tmr.timer"

local preload2 = "	", "\r", "\r\n", "[\r\n]", ",", ":", ";", " ", "  ", "                ", '"', '%q,\r\n',
"%02d-%02d %02d:%02d:%02d.%03d", "(.*)%.(l[uc]a?)", "=stdin",
"@_init.lua", "@lcd1602.lua", "@utils.lua", "@gpioTrig.lua", "@test.lua", "@roomControl.lua",
"@wifiConn.lua", "test", "test.lua", "gpioTrig.lua", "ide.lua", "lfs.img", "@lcd1602_setup.lua",
"roomControl.lua", "D", "HIGH", "INT", "LFS", "LFS is readonly. Invalid write to LFS.", "LOW",
"Lua 5.1", "Module not in LFS", "RAM", "_VERSION", "_config", "_list", "_time",
"abs", "concat", "crypto.hash", "day", "down", "epoch2cal", "error", "floor", "format",
"fs_mapped", "fs_size", "fscfg", "gpio", "gsub", "high", "hour", "kv", "lc", "led", "ledPin",
"lfs_base", "lfs_mapped", "lfs_size", "listFile", "loadfile", "local preload=",
"log.txt", "low ", "low: ", "math", "max", "min", "mode", "mon", "now", "onTrigHigh",
"onTrigLow", "printFile", "printLog", "printTableSorted", "readline",
"regTrig", "rep", "result", "resume", "running", "sec", "sort", "trig", "trigHighTimes",
"trigLowTimes", "unpack", "up", "websocket.client", "wifi.packet", "writeFile", "writeLog", "yield",
"coroutine", "heap", "heap = ", "insert", "lcd", "await", "loadImg", "log",
"needIgnoreTrig", "readImg", "usPerMs", "usPerSecond", "wrap", "task", "lfsOta",
"conn", "connect", "fileList", 'ram.txt', "ms.", ',\r\n', 'printRam', 'rtctime'

local preload_lcd = "TRANSMITTER", "_adr", "_ctl", "lcd1602.lua",
"NodeMCU", "Version 2.2.1", "bootTextDisplaying", "checkBootText", "clear", "define_char",
"delay", "function", "init", "light", "lightOnAWhile",
"locate", "number", "put", "showBootText", "type"

local preload_wifi = '\n\tSTA - CONNECTED', '\n\tSSID:  ', '\n\tBSSID: ', '\n\tChannel: ', '\n\tSTA - GOT IP: ',
'\n\tSTA - DISCONNECTED', '\n\tSSID:   ', '\n\tBSSID:  ', '\n\treason: ',
'SSID', 'BSSID', 'IP', 'reason', 'channel', 'gateway', 'ssid', 'pwd', 'ip', '255.255.255.0', '255.255.255.0',
"\"unixtime\":\"", '"on_off_status":1', "CogitoErgoSum", "HTTP request failed: ",
"Time updated: ", "Trig ignored, remain ", "W:", "afterWifiConnected",
"config", "connectedWifi", "getTime", "updateTime", "updateWifiStatusLcd",
"http", "httpGet", "httpGet Failed", "httpRequestRunning", "httpTasks",
"http://worldtimeapi.org/api/timezone/Asia/Taipei",
'receive', 'disconnection', 'ok', 'connection', 'GET /', 'get',
' HTTP/1.0\r\n', 'Host: ', 'Connection: close\r\n', 'Accept-Charset: utf-8\r\n', 'Accept-Encoding: \r\n',
'User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n', 'Accept: */*\r\n\r\n',
'File downloaded: ', "createConnection", "download", 'payloadFound', '\r\n\r\n', 'System ON'

local preload_roomControl = 'roomOn', 'roomOff', 'getSp3State', 'toggleRoomLight', 'toggleRoomLight',
'roomOnUrl', 'roomOffUrl', 'sp3StateUrl', 'get SP3 state', '"on_off_status":1', 'on'

local preload_gpioTrig = 'ignoreOneTrig', 'ignoreOneTrigUntil'

-- Don't preload those string that cause lcd1602 display garbled.
--local preload_ignore = "i2c", "address", "start", "stop", "write", "lshift", "band", "bit"
