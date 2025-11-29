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
