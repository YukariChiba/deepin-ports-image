#!/bin/bash

PWMDEV=/sys/class/pwm/pwmchip0

echo 1 > $PWMDEV/export
PWMNODE=$PWMDEV/pwm1

echo 25000 > $PWMNODE/period
# echo 15000 > duty_cycle #fan slow
echo 24000 > $PWMNODE/duty_cycle #fan fast
echo normal > $PWMNODE/polarity

echo 1 > $PWMNODE/enable
