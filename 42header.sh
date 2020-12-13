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

FILL_LENGTH=$(($WIDTH / ${#FILL} - ${#START} - ${#END} - 2))
PADDING_LEFT=$(($MARGIN - ${#START}))
PADDING_RIGHT=$(($MARGIN - ${#END}))

CONTENT_WIDTH=$(($WIDTH - $ASCII_ART_WIDTH - 2 * $MARGIN))

HEADER="\
/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   bg.c                                               :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: pablo <pablo@student.42lyon.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/11/18 23:11:42 by pablo             #+#    #+#             */
/*   Updated: 2020/12/12 21:59:55 by pablo            ###   ########lyon.fr   */
/*                                                                            */
/* ************************************************************************** */\
"

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

header_content()
{
	printf "$START"
	printf ' %.0s' $(eval "echo {1.."$(($PADDING_LEFT))"}")
	printf '%-*s' "$CONTENT_WIDTH" "$1" "$ASCII_ART_WIDTH" "$2"
	printf ' %.0s' $(eval "echo {1.."$(($PADDING_RIGHT))"}")
	printf "$END\n"
}

header()
{
	if [ -f "$1" ]; then
		FILENAME=$(basename "$1")
		CREATED_AT=$(git_time_created $1)
		UPDATED_AT=$(git_time_updated $1)

		header_fill "$FILL" "$FILL_LENGTH"
		header_fill " " "$FILL_LENGTH"

		header_content "" "${ASCII_ART[0]}"
		header_content "$FILENAME" "${ASCII_ART[1]}"
		header_content "" "${ASCII_ART[2]}"
		header_content "By: $USER <$MAIL>" "${ASCII_ART[3]}"
		header_content "" "${ASCII_ART[4]}"
		header_content "Created: $CREATED_AT" "${ASCII_ART[5]}"
		header_content "Updated: $UPDATED_AT" "${ASCII_ART[6]}"

		header_fill " " "$FILL_LENGTH"
		header_fill "$FILL" "$FILL_LENGTH"
	fi
}

header srcs/main/main.c

#for src in **/*.c; do
#	echo $src: $(git_time_created $src) $(git_time_updated $src)
#done
