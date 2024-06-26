# macbook-battery-monitor

A shell script for use in a crontab to log parameters for debugging macbook batteries, along with a jupyter / bokeh dashboard

Born out of my frustration with battery drain problems on my 2017 and 2018 macbook pro machines. In particular, I've been fighting endless problems with the battery draining when the lid is closed and sleeping: it spontaneously starts getting hot at random times (like after it has been in my bag for 1.5 hours), starts running both fans and drains battery. 

My solution is to keep some logfiles that I can analyze in python. The logfiles are generated by a script that I put in my crontab (`crontab -e`):

```
*/2 * * * * /Users/gsteele/bin/log_battery.sh
```

Also, since it is a script, if something funky is going on, I can always open up a terminal and run it a few times. 

It generates multiple logfiles in a folder `~/logs`, which you must create manually:

```
battery_percent.dat
battery_status.log
cpu_temp.dat
resources_status.log
```

The `.dat` files contain plottable data, and the `.log` files contain information that I found could be useful for debugging, like the full battery status message, and a record from `ps` with top 5 processes sorted by CPU usage. They are deliminated and timestamped, for potential future analysis. 

For the CPU temperature, I downloaded and compiled this program:

https://github.com/lavoiesl/osx-cpu-temp

It was very easy to compile (all that is needed is the stardard xcode dev tools), but I include a intel binary here for convenience (if it doesn't work for you, you can clone the repo and build it yourself is probably best). 

## Some lessons I've learned so far

BTW, the CPU temperature logging was very insightful: it told me that the reason my macbook was going mad in my bag was NOT because there was some rogue process that was stopping the machine from sleeping properly. The evidence was that although the fans were going totally mad, and although the metal case was nearly uncomfortably hot to the touch, the CPU temperature was only 50 degrees when I logged it just after opening the lid. This suggests that the CPU **was not!!!!** the source of the heat: there must be something else going on. 

For reference, the temperature of the case felt hotter than it gets when I run CPU intensive stuff: concretely, even after extended periods with the CPU running at 80 degrees, the case was still cooler than when I had the sleeping-heat problem. OK, it was in my bag, but still it's pretty clear that the CPU was not causing the problem, corroborated by the fact that the screen was dark when I opened the lid and had to wake it up by tapping the keyboard. 

I have been having similar problems with this machine for a least 2-3 years. The battery wore down and a year ago, I replaced the battery, but the problems continue: the problems are present even with a brand new battery. I've been trying lots of stuff and hope at some point that with this logging, I can find out what is triggering the sleep-heat problem. 
