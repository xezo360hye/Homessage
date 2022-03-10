#!/bin/bash

# $ADMIN will return 1 if not an admin; I used this in if-else later ("if $ADMIN; then" instead of "if [[ $ADMIN ]]; then")
# This is neccessary because if ADMIN will be empty/unset if statments will trigger
ADMIN=false

# $1 contains relative path to main forlder, e.g. if you start server in project dir it'll be . and if you start it like Homessage/start.sh it'll be Homessage
SELF="$1"


# Startup message
# Comment these lines to disable
echo -n "Welcome to Homessage!
Type your login and password:
> "

while read; do
	# Array is easier to use
	str=( $REPLY )

	# If user registered
	if [[ -n "$NAME" ]]; then
		# Check the command
		case "${str[0]}" in
			send)
				# The part [$(date +%T)] will look like [16:44:36]
				# You may want to change it to:
				# date "+%D %T"			-	[03/10/22 16:44:36]
				# date "+%y.%m.%d %T"	-	[22.03.10 16:44:36]
				# date "+%Y.%m.%d %T"	-	[2022.03.10 16:44:36]
				echo "[$(date +%T)] ${str[@]:2}" >> "$SELF/${str[1]}/$NAME"
				echo "Message sent";;
			get|new)
				# Data is stored in
				# If user specified then get new messages from that user only
				if [[ -n "${str[1]}" ]]; then
					cat "$SELF/$NAME/${str[1]}"
				# Otherwise get from all users
				else
					for file in $(ls "$SELF/$NAME"); do
						[[ -z "$(cat "$SELF/$NAME/$file")" ]] && continue
						echo "From $file:"
						while read; do
							echo "	$REPLY"
						done < "$SELF/$NAME/$file"
					done
				fi;;
			c|clear)
				# Clear history
				# If user specified, then delete only that user's messages
				if [[ -n "${str[1]}" ]]; then
					rm -f "$SELF/$NAME/${str[1]}"
				# Otherwise remove all
				else
					for file in $(ls "$SELF/$NAME"); do
						rm -f "$SELF/$NAME/$file"
					done
				fi
				echo "History cleaned";;
			# Add new user
			+user)
				if $ADMIN; then
					if [[ -n "${str[2]}" ]]; then
						mkdir "$SELF/${str[1]}"
						# The user.list file is something like admin 12345|testUser asdqwerty|new_user a
						# Where admin, testUser and new_user are usernames and 12345, asdqwerty and a are passwords
						echo -n "|${str[1]} ${str[2]}" >> "$SELF/users.list"
						echo "Added user to list"
					else
						echo "Usage: _user NAME PASS"
					fi
				else
					echo "You are not an admin!"
				fi;;
			# Add new admin
			+admin)
				if $ADMIN; then
					if [[ -n "${str[1]}" ]]; then
						# The user.list file is something like admin|testUser|new_user
						# Where admin, testUser and new_user are usernames
						echo -n "|${str[1]}" >> "$SELF/admins.list"
						echo "Added admin to list"
					else
						echo "Usage: _admin NAME"
					fi
				else
					echo "You are not an admin!"
				fi;;
			ping)
				# Why not
				echo "pong";;
			*)
				echo "Unknown command";;
		esac
	else
		# Check if login & password are correct
		if [[ "${str[0]} ${str[1]}" =~ ^($(cat "$SELF/users.list"))$ ]]; then
			NAME="${str[0]}"
			echo "Login success"
			# Check if admin
			if [[ "${str[0]}" =~ ^($(cat "$SELF/admins.list"))$ ]]; then
				ADMIN=true
				echo "Welcome, Admin!"
			fi
		else
			echo "Invalid name or password"
			# Uncomment to kick user after every incorrect attempt
			#break
		fi
	fi
done