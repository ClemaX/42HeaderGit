#!/bin/sh

CAMPUS="lyon.fr"
USER="chamada"
MAIL="$USER@student.42$CAMPUS"

HEIGHT=11
WIDTH=80
MARGIN=5

ASCII_ART=(
"        :::      ::::::::"
"      :+:      :+:    :+:"
"    +:+ +:+         +:+  "
"  +#+  +:+       +#+     "
"+#+#+#+#+#+   +#+        "
"     #+#    #+#          "
"    ###   ########$CAMPUS"
)
ASCII_ART_WIDTH=${#ASCII_ART[0]}

START="/*"
END="*/"
FILL="*"

HEADER_REGEX="^/\*.*\*/$"

FILL_LENGTH=$(($WIDTH / ${#FILL} - ${#START} - ${#END} - 2))
PADDING_LEFT=$(($MARGIN - ${#START}))
PADDING_RIGHT=$(($MARGIN - ${#END}))

CONTENT_WIDTH=$(($WIDTH - $ASCII_ART_WIDTH - 2 * $MARGIN))

git_time_created()
{
	git log --format=%ci "$1" | tail -n 1 | cut -d ' ' -f 1-2 | tr '-' '/'
}

git_time_updated()
{
	git log --format=%ci "$1" | head -n 1 | cut -d ' ' -f 1-2 | tr '-' '/'
}

header_fill()
{
	printf "$START "
	printf "$1"'%.0s' $(eval "echo {1.."$(($2))"}")
	printf " $END\n"
}

# header_content text ascii_art
header_content()
{
	printf '%s'		"$START"
	printf ' %.0s'	$(eval "echo {1.."$(($PADDING_LEFT))"}")
	printf '%-*s'	"$CONTENT_WIDTH" "$1" "$ASCII_ART_WIDTH" "$2"
	printf ' %.0s'	$(eval "echo {1.."$(($PADDING_RIGHT))"}")
	printf '%s\n'	"$END"
}

header()
{
	if [ -f "$1" ]; then
		FILENAME=$(basename "$1")
		CREATED_AT=$(git_time_created $1)
		UPDATED_AT=$(git_time_updated $1)

		header_fill "$FILL"	"$FILL_LENGTH"
		header_fill " "		"$FILL_LENGTH"

		header_content ""								"${ASCII_ART[0]}"
		header_content "$FILENAME"						"${ASCII_ART[1]}"
		header_content ""								"${ASCII_ART[2]}"
		header_content "By: $USER <$MAIL>"				"${ASCII_ART[3]}"
		header_content ""								"${ASCII_ART[4]}"
		header_content "Created: $CREATED_AT by: $USER"	"${ASCII_ART[5]}"
		header_content "Updated: $UPDATED_AT by: $USER"	"${ASCII_ART[6]}"

		header_fill " "		"$FILL_LENGTH"
		header_fill "$FILL"	"$FILL_LENGTH"
	fi
}

has_header()
{
	head -11 "$1" | grep -vq "$HEADER_REGEX" && return 1 || return 0
}

insert_header()
{
	printf '%s\n\n' "$(header "$1")"\
		| cat - "$1" > .header_tmp\
		&& mv .header_tmp "$1"
}

update_header()
{
	if has_header "$1" ; then
		: #echo "TODO: Update header!"
	else
		insert_header "$1"
	fi
}

SRCDIR=srcs
INCDIR=includes

# Update headers in .c files
for src in $(find srcs -type f -name "*.c"); do
	update_header "$src"
done

# Update headers in .h files
for head in $(find srcs -type f -name "*.h"); do
	update_header "$head"
done
