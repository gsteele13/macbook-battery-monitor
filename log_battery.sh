date=`date +%Y-%m-%d-%H:%M:%S`
percent=`pmset -g batt | grep Internal | cut -f2 | cut -d "%" -f 1`

echo $date $percent >> /Users/gsteele/logs/battery_percent.dat

echo "=====" >> /Users/gsteele/logs/battery_status.log
echo $date >> /Users/gsteele/logs/battery_status.log
pmset -g batt >> /Users/gsteele/logs/battery_status.log

echo "=====" >> /Users/gsteele/logs/resources_status.log
echo $date >> /Users/gsteele/logs/resources_status.log
ps aux -r | head -n 6 >> /Users/gsteele/logs/resources_status.log

echo $date $(/Users/gsteele/bin/osx-cpu-temp) >> /Users/gsteele/logs/cpu_temp.dat

