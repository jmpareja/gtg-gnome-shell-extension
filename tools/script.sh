#! /bin/bash

# Place this script in the same folder of .po files
# Choose patterns to search in files
# Run it
# Results in "gtgpo" folder

# Prepare destination folder
rm *~
rm gtgpo -rf
mkdir gtgpo

# String to search
open="msgid \"Open\"";
date="msgid \"%A, %B %d\"";
today="msgid \"Today\"";
tomorrow="msgid \"Tomorrow\"";
nothing="msgid \"Nothing Scheduled\"";

closed="msgid \"GTG is closed\"";
strClosed="msgstr \"GTG is closed\"";

# For each file in folder
for inode in $(ls -R)
do
	# Don't read .: file
	if [ $inode != ".:" ]
	then
		filename="./$inode"
		# Don't read bad files
		if [ $filename != $0 ]&&[ $filename != "././gtgpo:" ]&&[ $filename != "./gtgpo" ]
		then
			echo "Reading $filename ..."
			destFile=""
			# Read all strings of a file
			while read line  
			do   
				res=$(echo -e "$line\n"  | grep "$open\|$date\|$today\|$tomorrow\|$nothing");
				# If pattern found, add to destFile
				if [ ${#res} != 0 ]
					then
					# If the word "Open" is found
					if [ "$res" = "$open" ]
					then
						var=$(expr "$res" : "\(.*\).$")
						destFile="$destFile$var GTG\"\n"
						read line
						var=$(expr "$line" : "\(.*\).$")
						destFile="$destFile$var GTG\"\n"
					else
						destFile="$destFile$res\n"
						read line
						destFile="$destFile$line\n\n"
					fi
	
				fi
	
			done < $filename
			
			# Add "isclosed" item
			destFile="$destFile\n$closed\n$strClosed"
			# We can now create folders ans copy destFile
			foldername=${filename:2}
			foldername=${foldername%.po*}
			foldername="gtgpo/$foldername"
			# Create locale folder
			mkdir $foldername
			foldername="$foldername/LC_MESSAGES"
			# Create sub-folder
			mkdir $foldername
			# Copy contents in destination file
			echo -e $destFile > "$foldername/$filename"
		fi
	fi
done
