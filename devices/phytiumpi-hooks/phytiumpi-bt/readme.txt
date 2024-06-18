
bt固件及工具，在飞腾派文件系统下，拷贝对应的固件和工具，并启动bt_init服务,用于开机启动自动执行bt_init命令

   rm /lib/firmware/rtlbt/ -rf
   mkdir /lib/firmware/rtlbt
   cp ./rtl882* /lib/firmware/rtlbt
   cp rtk_hciattach_arm64  /usr/bin/rtk_hciattach

    服务
    sudo cp bt-init.service /lib/systemd/system/bt-init.service
    sudo cp bt_init /usr/bin/bt_init
    sudo chmod 777 /usr/bin/bt_init
    systemctl enable bt-init.service


