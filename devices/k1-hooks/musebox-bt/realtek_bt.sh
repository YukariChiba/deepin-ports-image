#!/bin/bash
bt_hciattach="rtk_hciattach"
start_hci_attach()
{
        h=`ps | grep "$bt_hciattach" | grep -v grep`
        [ -n "$h" ] && {
                killall "$bt_hciattach"
        }

        #realtek h5 init
        echo 0 > /sys/class/rfkill/rfkill0/state;
        sleep 1
        echo 1 > /sys/class/rfkill/rfkill0/state;
        sleep 1

        "$bt_hciattach" -n -s 115200 /dev/ttyS1 rtk_h5 >/dev/null 2>&1 &

        wait_hci0_count=0
        while true
        do
                [ -d /sys/class/bluetooth/hci0 ] && break
                sleep 0.1 
                let wait_hci0_count=wait_hci0_count+1
                [ $wait_hci0_count -eq 70 ] && {
                        echo "bring up hci0 failed"
                        exit 1
                }
        done
        return 0
}

hci_start() {
        echo 1 > /tmp/hci_fifo
}

hci_stop() {
        echo 0 > /tmp/hci_fifo
}

hci_start_imp()
{
        h=`ps | grep "$bt_hciattach" | grep -v grep`
        if [ -n "$h" ] ;then
                echo "Bluetooth init has been completed!!"
        else
                start_hci_attach
        fi
}

hci_stop_imp()
{

        h=`ps | grep "$bt_hciattach" | grep -v grep`

        if [ -n "$h" ] ;then
                echo 0 > /sys/class/rfkill/rfkill0/state;
                killall "$bt_hciattach"
        fi
        return 0
}

loop() {
        if [ ! -p "/tmp/hci_fifo" ];then
                mkfifo /tmp/hci_fifo
                chmod 666 /tmp/hci_fifo
        fi
        rfkill_node=$(cat /sys/class/rfkill/rfkill0/name)
        spacemit_bt_node="spacemit-bt"
        if [ "$spacemit_bt_node" != "$rfkill_node" ];then
                return
        fi
        hci_start_imp
        while true;do
                read flag < /tmp/hci_fifo
                echo $flag
                if [[ "$flag" -eq 1 ]];then
                        hci_start_imp
                else
                        hci_stop_imp
                fi
                sleep 1
        done
}

ble_start() {
        if [ -d "/sys/class/bluetooth/hci0" ];then
                echo "Bluetooth init has been completed!!"
        else
                start_hci_attach
        fi

        hci_is_up=`hciconfig hci0 | grep UP RUNNING`
        [ -z "$hci_is_up" ] && {
                hciconfig hci0 up
        }

        MAC_STR=`hciconfig | grep "BD Address" | awk '{print $3}'`
        LE_MAC=${MAC_STR/2/C}
        OLD_LE_MAC_T=`cat /sys/kernel/debug/bluetooth/hci0/random_address`
        OLD_LE_MAC=$(echo $OLD_LE_MAC_T | tr [a-z] [A-Z])
        if [ -n "$LE_MAC" ];then
                if [ "$LE_MAC" != "$OLD_LE_MAC" ];then
                        hciconfig hci0 lerandaddr $LE_MAC
                else
                        echo "the ble random_address has been set."
                fi
        fi
}

case "$1" in
  loop|"")
        loop
        ;;
  ble_start)
            ble_start
                ;;
  hci_start)
                hci_start
                ;;
  hci_stop)
                hci_stop
                ;;
  *)
        echo "Usage: $0 {start|stop}"
        exit 1
esac
