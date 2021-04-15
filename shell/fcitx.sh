
#!/bin/bash
# 解决fcitx在使用过程中突然消耗大量资源的问题。
PROCESS="fcitx"

function get_pid_x { #process
        PID=""
        while [ ! $PID ]; do
                PID=$(pidof $1)
                sleep 1
        done
        echo $PID
}

function get_consume_cpu_process { #PID
        echo $(top -b -p $1 -n 1 | tail -n 1 | awk '{print $9}')
}

pid=$(get_pid_x $PROCESS)
while [[ 1 ]]; do
        #echo "the fcitx's pid is $pid"
        #echo "the fcitx consumes $(get_consume_cpu_process $pid)%"
        if [[ $(get_consume_cpu_process $pid) > 10.0 ]]; then
                times=4
                while [[ times > 0 ]]; do
                        sleep 1
                        times=$(($times-1))
                        if [[ $(get_consume_cpu_process $pid) < 10.0 ]]; then
                                break
                        elif [[ $(get_consume_cpu_process $pid) > 10.0 && times = 0 ]]; then
                                #echo "kill the process $pid."
                                kill $pid
                                pid=$(get_pid_x $PROCESS)
                                #else
                                #echo "not need to kill the process $pid"

                        fi
                done
        fi
        sleep 4
done


