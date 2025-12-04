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
read -p "Enter the PID of the process to terminate (OR Enter to skip): " pid
if [ -z "$pid" ]; then
    echo "Skipping process termination."
else
    ps -p "$pid"
    sudo kill "$pid"
    echo "Process terminated."
fi
read -p "Press Enter to return to the menu..."
}

backup_management(){
echo "=== Backup Management ==="
read -p "Press Enter to skip backup creation, or type anything to continue: " proceed
    if [ -z "$proceed" ]; then
        echo "Skipping backup creation."
        return
    fi
read -p "Enter the file name you would like to create a backup schedule for: " file
read -p "Enter the day of the week you want to schedule the backup(1-7): " day
read -p "Enter the time you want to schedule the backup (HH:MM, 24-hour format): " time
read -p "Enter the full path of the destination of the file: " dest
minute=$(echo "$time" | cut -d":" -f2)
hour=$(echo "$time" | cut -d":" -f1)
cron_tab="$minute $hour * * $day cp $file $dest"
(crontab -l  2>/dev/null; echo "$cron_tab") | crontab -
echo "File backup schedule created successfully!"
}

create_user(){
read -p "Enter username: " username
read -p "Enter password: " password

sudo useradd -m "$username"
echo "$username:$password" | sudo chpasswd
}

grant_root(){
read -p "Enter the name of the user you wish to grant root privileges: " username
sudo usermod -aG sudo "$username"
}

delete_user(){
read -p "Enter the name of the user you wish to delete: " username
sudo deluser --remove-home "$username"
}

display_users(){
echo "Currently connected users:"
who
}

disconnect_user(){
read -p "Enter username you wish to disconnect: " username
sudo pkill -kill -u "$username"
}

show_groups_of_user(){
read -p "Enter username you wish to show it's groups: " username
groups "$username"
}

add_user_to_group(){
read -p "Enter username you wish to add to a group: " username
read -p "Enter the name of the group: " group
sudo usermod -aG "$group" "$username"
}

remove_user_of_group(){
read -p "Enter username you wish to remove of a group: " username
read -p "Enter the name of the group: " group
sudo gpasswd -d "$username" "$group"
}

user_management(){
while true; do
echo "Select task to perform: "
select task in "Create User" "Grant root" "Delete user" "Display list of users" "Disconnect remote user" "Show all groups of a user" "Add user to group" "Remove user of group" "Exit"
do
case $task in
"Create User")
create_user
break
;;
"Grant root")
grant_root
break
;;
"Delete user")
delete_user
break
;;
"Display list of users")
display_users
break
;;
"Disconnect remote user")
disconnect_user
break
;;
"Show all groups of a user")
show_groups_of_user
break
;;
"Add user to group")
add_user_to_group
break
;;
"Remove user of group")
remove_user_of_group
break
;;
"Exit")
return
;;
esac
done
done
}
find_file(){
read -p "Enter username: " username
read -p "Enter filename: " filename

if id "$username" &>/dev/null; then
home_dir="/home/$username"
result=$(find "$home_dir" -name "$filename" 2>/dev/null)

if [ -n "$result" ]; then
echo "File found at:"
echo "$result"
else
echo "File not found"
fi
else
echo "User doesn't exist."
return
fi
}

largest_files(){
read -p "Enter username: " username

if id "$username" &>/dev/null; then
home_dir="/home/$username"
else
echo "User doesn't exist"
return
fi

echo "10 Largest files in $home_dir:"
find "$home_dir" -type f -exec ls -lh {} + 2>/dev/null | sort -k5 -h | tail -n 10
}

oldest_files(){
read -p "Enter username: " username

if id "$username" &>/dev/null; then
home_dir="/home/$username"
else
echo "User doesn't exist."
return
fi
echo "10 Oldest files in $home_dir:"
find "$home_dir" -type f -printf "%T+ %p\n" 2>/dev/null | sort | head -n 10
}

file_management(){
while true; do
echo "Select an option:"
select option in "Find a file" "10 Largest files" "10 Oldest files" "Exit"
do
case $option in
"Find a file")
find_file
break
;;
"10 Largest files")
largest_files
break
;;
"10 Oldest files")
oldest_files
break
;;
"Exit")
return
;;
esac
done
done
}
network_management(){
echo "=== Network Management ==="
echo
select option in "Show all Network Interfaces" "Enable a Network Interface" "Disable a Network Interface" "Assign IP Address to a Network Card" "Display all Available Wi-Fi Networks" "Exit"; do
	case $REPLY in

		1)
		    # Displays all network interfaces, along with their IP addresses and default gateways
		    echo
		    echo "Network Interfaces and IP Addresses"
		    ip -br addr
                    echo
                    echo "Default Gateways"
		    ip route show default
                    echo
        	    read -p "Press Enter to return to menu..."
		    echo
                    ;;

		2)
		    echo
                    read -p "Enter a Network Interface you Wish to Enable (example: eth0): " iface
                    sudo ip link set "$iface" up
                    echo "Network Interface '$iface' is now enabled"
		    echo
                    read -p "Press Enter to return to the menu..."
		    echo
		    ;;

		3)
	            echo
		    read -p "Enter a Network Interface you Wish to Disable (example: eth0): " iface
		    sudo ip link set "$iface" down
		    echo "Network Interface '$iface' is now disabled"
		    echo
		    read -p "Press Enter to return to the menu..."
                    ;;

		4)
		   echo
		   read -p "Enter an interface name (example: eth0): " iface
		   echo
	           read -p "Enter the IP address with the CDIR (example: 192.168.1.50/24): " ipaddr

		   sudo ip addr flush dev "$iface"
                   sudo ip addr add "$ipaddr" dev "$iface"
                   sudo ip link set "$iface" up
                   echo "Assigned IP $ipaddr to interface $iface"
		   echo
		   read -p "Press Enter to return to the menu..."
                   ;;

		5)
		    echo "Available Wi-Fi Networks:"
		    sudo nmcli device wifi list
		    echo
		    read -p "Enter SSID to connect to: " ssid
		    echo
	            read -p "Enter Wi-Fi password: " password
		    echo

		    sudo nmcli device wifi connect "$ssid" password "$password"
		    echo "Connecting to '$ssid'..."
		    echo
		    read -p "Press Enter to return to the menu..."
                    ;;
		6)
                    echo "Returning to main menu..."
                    return
		    ;;
		*)
                    echo "Invalid Option. Please Try Again"
                    ;;

    esac
done
}
service_management(){
    echo "=== Service Management ==="
echo
select option in "Show all running services" "Start a service" "Stop a service" "Exit"; do
    case $REPLY in

        1)
            # Displays current running services
            echo "Currently Running Services:"
            systemctl --no-pager list-units --type=service --state=running
            echo
            read -p "Press Enter to return to the menu..."
            echo
            ;;

        2)
            echo -n "Enter the service name to START (example: ssh): "
            read servicename
            sudo systemctl start "$servicename"
            echo "Service '$servicename' started"
            read -p "Press Enter to return to the menu..."
            echo
            ;;

        3)
            echo -n "Enter the service name to STOP (example: ssh): "
            read servicename
            sudo systemctl stop "$servicename"
            echo "Service '$servicename' stopped"
            read -p "Press Enter to return to the menu..."
            echo
            ;;

        4)
            echo "Returning to main menu..."
            return
            ;;

        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done
}

while true; do
clear
echo "Select the function to run:"
echo "1) System Status"
echo "2) Backup Management"
echo "3) Network Management"
echo "4) Service Management"
echo "5) User Management"
echo "6) File Management"
echo "7) Exit"
read -p "Choose your option: " option

case $option in
1)
system_status
;;
2)
backup_management
;;
3)
network_management
;;
4)
service_management
;;
5)
user_management
;;
6)
file_management
;;
7)
echo "Exiting program..."
break
;;
esac
echo
read -p "Press Enter to continue..."
done
