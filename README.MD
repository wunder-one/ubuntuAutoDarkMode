# Auto Dark Mode for Ubuntu
This repository contains the scripts needed to automatically switch from light mode to dark mode in Ubuntu with Gnome desktop.

## How it works
The **getSunriseAndSunset** script makes a query to the [Sunrise and Sunset API](https://sunrise-sunset.org/api) with the coordinates that are hardcoded in the file. From it it obtains the sunrise and sunset times and saves that information in the times.json file

**turnMode** checks the current time and reads the data from times.json. Based on that information, change the visual theme to Yaru-light or Yaru-dark as appropriate.

## Dependencies
* **curl** for API fetch
* **jq** for JSON convert
* **cron** for schedule turnMode each 5 minutes
* **anacron** for schedule API query once a day

## Limitations
This script was only tested on Ubuntu 22.04 with Gnome desktop. If you want to use it on other systems, some instructions must be replaced

## Installation
* clone the repository inside a folder, for example /home/[user]/Public

* add execute permission to sh files:

    `chmod +x *.sh`

* edit local coordinates hardcoded in setSunriseAndSunset.sh

  You can get the approximate latitude and longitude of your IP at https://www.geolocation.com


* add schedule to **anacron**:

  * Edit the anacron file

    `sudo nano /etc/anacrontab`

  * add at the bottom:

    `@daily  30  update-sunset  /home/[user]/path/to/getSunriseAndSunset.sh`

    this means dayly execution with 30 minutes delay
    
    update-sunset is a random name for log purposes

* add schedule to **cron**

  * edit crontab:
  
    `crontab -e`

  * add at bottom of file:

    `*/5 * * * * /home/[user]/path/to/turnMode.sh`

    `*/5` means call each 5 minutes

    `* * * *` means no hours, day, month or weekday
