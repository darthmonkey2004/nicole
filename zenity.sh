#!/bin/bash


err() {
	zenity --error --title="An Error Occurred " --text="A problem occurred while running the shell script. "
}
yesNo() {
	zenity --question --title="Query " --text="Would you like to run the script? "
}
textEntry() {
	zenity --entry --title="Favorite Website " --text="What is your favorite website? "
{
rmFile() {
	zenity --title="Select a file to remove" --file-selection
}
floodPing() {
	zenity --title "Select Host" --entry --text "Select the host you would like to flood-ping"
}
alert() {
	zenity --question --title "Alert" --text "Microsoft Windows has been found! Would you like to remove it?"
}
searchResults() {
	find . -name '*.h' | zenity --list --title "Search Results" --text "Finding all header files.." --column "Files"
}
notifyToTray() {
	zenity --notification --window-icon=update.png --text "System update necessary!"
}
shoppingList() {
	zenity --list --checklist --column "Buy" --column "Item" TRUE Apples TRUE Oranges FALSE Pears FALSE Toothpaste
}
searchWithProgress() {
	 find $HOME -name '*.ps' | zenity --progress --pulsate
}
timer() {
	TIME=$(zenity --entry --title="Timer" --text="Enter a duration for the timer.\n\n Use 5s for 5 seconds, 10m for 10 minutes, or 2h for 2 hours.")
	sleep $TIME
	zenity --info --title="Timer Complete" --text="The timer is over.\n\n It has been $TIME."
}

searchWithProgress;
shoppingList;
notifyToTray;
searchResults;
err;
textEntry;
rmFile;
alert;
floodPing;
timer;
