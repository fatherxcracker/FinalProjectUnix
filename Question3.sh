# Network Management
echo "------------------"
echo "Network Management"
echo "------------------"
select option in "Show all Network Interfaces" "Enable a Network Interface" "Disable a Network Interface" "Assign IP Address to a Network Card" "Display all Available Wi-Fi Networks" "Exit"; do
	case $REPLY in

		1)
		    # Displays all network interfaces, along with their IP addresses and default gateways
		    echo "Network Interfaces and IP Addresses"
		    ip -br a
                    echo
                    echo "Default Gateways"
		    ip route show default
                    echo
                    read -p "Press Enter to return to menu..."
                    ;;

		2)
                    echo -n "Enter a Network Interface you Wish to Enable (example: eth0): "
		    read iface
                    sudo ip link set "$iface" up
                    echo "Network Interface '$iface' is now enabled"
                    echo read -p "Press enter to return to the menu..."
		    ;;

		3)
                    ;;
		4)
                    ;;
		5)
                    ;;
		6)
                    echo "You have exited the Application"
                    break
		    ;;
		*)
                    echo "Invalid Option. Please Try Again"
                    ;;

    esac
done
