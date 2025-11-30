#!/bin/bash
system_status(){
echo "=== Memory Usage ==="
 free -h

echo "=== CPU Temperature ==="
 if command -v sensors &> /dev/null; then
    threshold=70
    cpu_temp=$(sensors | awk '/Tctl/ {print $2}')
    if [ -z "$cpu_temp" ]; then
    cpu_temp=$(sensors | awk '/Core 0:/ {print $3}')
    fi
    cpu_num=${cpu_temp//[^0-9.]/}
  if (( $(echo "$cpu_num > $threshold" | bc -l) )); then
    echo "WARNING: CPU TEMPERATURE EXCEEDS THRESHOLD."
  else
    echo "CPU Temperature ($cpu_temp) is within threshold."
  fi
else
    echo "sensors command not found."
  fi

echo "=== All System Processes ==="
 ps aux

echo "=== Terminate a Process ==="
read -p "Enter the PID of the process to terminate: " pid
ps aux | grep "$pid"
sudo kill "$pid"
}

backup_management(){
echo "=== Backup Management ==="
read -p "Enter the file name you would like to create a backup schedule for: " file
read -p "Enter the day of the week you want to schedule the backup(1-7): " day
read -p "Enter the time you want to schedule the backup (HH:MM, 24-hour format): " time
read -p "Enter the full path of the destination of the file: " dest
minute=$(echo "$time" | cut -d":" -f2)
hour=$(echo "$time" | cut -d":" -f1)
cron_tab="$minute $hour * * $day cp \"$file\" \"$dest\""
(crontab -l  2>/dev/null; echo "$cron_tab") | crontab -
echo "File backup schedule created succesfully!"
}

while true; do
clear
echo "Select the function to run:"
echo "1) System Status"
echo "2) Backup Management"
echo "3) Exit"
read -p "Choose your option: " option

case $option in
1)
system_status
;;
2)
backup_management
;;
3)
echo "Exiting program..."
break
;;
esac
echo
read -p "Press Enter to continue..."
done
