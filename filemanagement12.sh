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
