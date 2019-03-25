return {
  ssid = 'yourWifiSSID',
  pwd = 'yourWifiPassword',
  -- If you want to set static ip.
  -- ip = '192.168.1.161',
  -- ip = node.chipid() == 2732216 and '192.168.4.161' or '192.168.4.160', -- static ip per chip.
  -- gateway = '192.168.4.1',
  -- Replace it with yours url found in RM Plugin API Server site.
  roomOnUrl = 'http://192.168.1.150:9876/send?deviceMac=34ea34bf663a&codeId=19',
  roomOffUrl = 'http://192.168.1.150:9876/execute?macroId=eca1226d-40a7-4e3f-9a80-e4f1482a5306',
  sp3StateUrl = 'http://192.168.1.150:9876/status?deviceMac=34:ea:34:24:43:e5',
  -- Loading LFS image from this file server.
  fileServerIp = '192.168.1.121',
}