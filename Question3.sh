# Network Management
echo "Network Management"
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
                    echo "You have exited the Application"
                    exit 0
		    ;;
		*)
                    echo "Invalid Option. Please Try Again"
                    ;;

    esac
done
