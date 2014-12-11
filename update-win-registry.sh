#!/usr/bin/bash

REG_KEY="$1"
SEARCH="$2"
REPLACE="$3"

function read_keys
{
	regtool list --keys "$1"
}

function read_list
{
	regtool list --list "$1"
}

function read_recursively_keys
{
	local arg="$1"
	read_keys "$arg" | \
		while read key
		do
#			read_list "$1/$key"
			echo "$arg/$key"
			read_recursively_keys "$arg/$key"
		done
}

function read_list_all
{
	read_recursively_keys "$1" | \
		while read reg_key
		do
			read_list "$reg_key" | \
			while read reg_key_list
			do
				val="$reg_key/$reg_key_list"
				echo "$val" >&2
				value=$(regtool get "$val")
				if [[ "$value" == *$SEARCH* ]]
				then
					echo REPLACE: "$val"
					REPLACED=${value/$SEARCH/$REPLACE}
					echo \"$value\" with \"$REPLACED\"
#					echo regtool set "$val" \<REPLACE\>
				fi
			done
		done
}

read_list_all "$REG_KEY"
