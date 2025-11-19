# Display all running services at start
echo "Currently Running Services "
systemctl list-units --type=service --state=running
echo

# Menu loop
select option in "Start a service" "Stop a service" "Exit"; do
    case $REPLY in
        1)
            echo -n "Enter the service name to START (example: ssh): "
            read servicename
            sudo systemctl start "$servicename"
            echo "Service '$servicename' started"
            ;;
        2)
            echo -n "Enter the service name to STOP (example: ssh): "
            read servicename
            sudo systemctl stop "$servicename"
            echo "Service '$servicename' stopped"
            ;;
        3)
            echo "You have exited the application."
            break
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
done