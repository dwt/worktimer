# TODO
* copy aus der auswertung erlauben, damit ich die weitere auswertung in numbers/excel/jupyter machen kann
* Tracken wie lange ich arbeiten will -> über / unterstanden
* Eingeben können wenn Feiertag / Krank / Urlaub ist (um Überstunden zu tracken)
* Migrate to new data model: what / context, @tags
* Auswertung über die tags (`work@sntl`, `work@inside`) tag, woche, monat
* Document how to add and test CoreData migrations
    * [Core Data Migration](https://web.archive.org/web/20100821040018/http://sunflower.coleharbour.ca/cocoamondo/2009/06/core-data-migration/)
    * [Core Data Migration Problems?](https://web.archive.org/web/20151028171009/http://iphonedevelopment.blogspot.com/2009/09/core-data-migration-problems.html)


# Goals
* Worktimer assumes that you are working on one thing only at the same time
* Worktimer makes it really easy to enter a task you are working on right now
* Worktimer periodically (~15min) asks if you are still working on that task or if you would like to log one now
* Worktimer gives you some basic statistics on where you are spending your time
* Worktimer has a really nice way of entering all information needed from one string 

# Code TOODs
* Get some acceptance tests going (not sure what this would mean in cocoa-land. Perhaps driving the GUI by sending it messages?)
    * Try to use accessibility api for this
    * Want to be able to run unit and acceptance tests separately
    * Consider to use macruby to write acceptance tests (with rspec or cucumber?)

# Code TODOs LATER
* Refactor data model to have metadata (just a string or separate fields?) Design criteria:
    * Should be able to track stuff I do for work
    * Should be able to track stuff I do for work, support, scrum master
    * Should be able to track specific stuff I'm doing
    * Prefix matches on the text could be the best way to go there
    * tags may be more valuable? (not sure how to implement that with CoreData, perhaps n<->m connection?)
    * Needs ability to filter by arbitrary tags then (search interface?, tag:foo, tag:bar?)

# Radical new interface
* One big button: Start/Stopp -> Enter should trigger?
* Big graph directly below it, details view and details editing in another window / hidden per default?
* Big display of how long I'm already working on something
* Show list of things I did today / yesterday / a specific day / last week
* Global Hotkey to enable disable timer?
* Stop timer when computer goes to sleep / display is locked?
* Growl notifications every 15 minutes when working on something / when working on nothing
* Quinn (Tetris) has nice display code for big digital time view

# Ideas
* Better overview of the data
    * Consider to integrate with THCalendarInfo http://theocacao.com/document.page/389
    * How much overtime (if you're on payroll)
    * Consider special rules like 16h of overtime to be free for the employer
    * How many hours did I work today?
    * How long where my pauses per day?
* Always show entries in the order they where made
* Either integrate the datamining in the main window or always align it to the main window
* Consider to support multiple project with NSDocument?
* Open last project automatically?
* Release it to macupdate and Versiontracker
    * for your enjoyment only
* show the current worktime if working on the project, something like "current workitem: 1:35" or something
    * Perhaps the total worktime for today in the dock or in a NSStatusMenuItem?
        * Length of last task perhaps?
        * Configurable?
* select the corresponding workitems when a specific worktime is selected in the overview
* Show weekly work as graph
* Try speech recognition for "Start", "Stop", "Lunch" etc.
* Show nice graphs of the time spent and where
* It should be able to still give me meaningfull analysis when I have sicktime, vacation or am on a training
* Find nice bridge-days or other opportunities to get rid of overtime by integrating with iCal?
    * Get goals from that: more than xx overtime till yy so I can take the leave zz
* Get it to integrate nicely with a GTD application so it is dead easy to plan projects in advance. It should support goal setting, priorisation, task breakdown, execution and review
* Extra super bonus points if it is network aware and can form ad hoc networks with other instanc eof the app securely if you want
* Worktimer als open source veröffentlichen
