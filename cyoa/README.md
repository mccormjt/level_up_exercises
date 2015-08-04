## Choose Your Destiny

We're going to spend some time on this one, so it's time to Choose Your Own Adventure™. You'll be writing one of these Rails applications and refactoring it for a while, so pick something interesting.

The goal here is to consume and transform an API that is provided elsewhere. Integration of third party functionality core to a lot of what we do, so you need the practice.

* If you're new in town, think about building the [Local Events Aggregator](../happenings/).
* If you like a challenge, advance to the [Congressional Good Deeds Feed](../opposite_of_progress/).
* If none of these things apply to you, but you have experienced weather events in the past, turn to page 46 and take a big whiff of the [Forecast Reminder](../event_system/).
* Alternatively, if none of these strike your fancy, find an API to consume, transform and republish and work with me to make sure it fits the bill. As a few ideas:
  * https://api.23andme.com/docs/reference/
  * http://build.kiva.org/api
  * https://api.stackexchange.com/docs
  * https://developers.google.com/youtube/
  * https://api.slack.com/

Good luck!




========================== FollowUp Project Outline =====================================

The API I want to use is some free tier SMS API like Twilio. The app would be called "FollowUp" and the purpose of it would be to create tasks for people and assign them via phone number. You can also make teams or groups of people to assign tasks to. But the main point of it is that it will have background workers that automatically text and follow up with people of the task when they still havent completed it. Depending on when you set the due date and how long the task will take the app will "pester" the person who is supposed to do the task with FollowUp text messages asking for status updates.They can quick reply 1-4 for answers like UNSTARTED, STARTED, BLOCKED, FINISHED, or just a custom message. Then the task creator will see these status updates in real time. The app will send followUp texts more and more frequently the sooner the due date gets without being finished (also will depend on how long the task will take). I want to create a mobile friendly front end where users can create and view these tasks / status updates as well. 

The value from this app comes from not having to followUp with people on everyday tasks and TODOs. But even more so because the creator cannot (on purpose) configure the frequency of the reminders.....there is less direct frustration with the person who created the tasks because they are not the ones controlling the frequency of pestering....its taskees own fault they are starting to get lots of messages because they didnt complete the task on a nearing deadline.
