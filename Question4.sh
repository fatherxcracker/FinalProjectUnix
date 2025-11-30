echo "Service Management"
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
            read -o "Press Enter to return to the menu..."
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
            echo "You have exited the application."
            exit 0
            ;;

        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done
