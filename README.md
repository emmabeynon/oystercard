Oystercard Challenge
==================

Author: Emma Beynon

Github: https://github.com/emmabeynon

Email: emma.beynon@gmail.com


This is my submission for the Makers Academy Week 2 Project: https://github.com/makersacademy/course/tree/master/oystercard

Overview
---------
This challenge involved writing an Oystercard system with the below user stories.

User Stories
------------
```
In order to use public transport
As a customer
I want money on my card

In order to keep using public transport
As a customer
I want to add money to my card

In order to protect my money
As a customer
I don't want to put too much money on my card

In order to pay for my journey
As a customer
I need my fare deducted from my card

In order to get through the barriers
As a customer
I need to touch in and out

In order to pay for my journey
As a customer
I need to have the minimum amount for a single journey

In order to pay for my journey
As a customer
I need to pay for my journey when it's complete

In order to pay for my journey
As a customer
I need to know where I've travelled from

In order to know where I have been
As a customer
I want to see to all my previous trips

In order to know how far I have travelled
As a customer
I want to know what zone a station is in

In order to be charged correctly
As a customer
I need a penalty charge deducted if I fail to touch in or out

In order to be charged the correct amount
As a customer
I need to have the correct fare calculated
```

Instructions
------------
1. Fork this repo and clone to your local machine.
2. Launch pry or irb
3. Require './lib/oystercard.rb'
4. Interacting with the programme:

```
> card = Oystercard.new #creates a new oyster card
> card.top_up(10) #tops up the card
> station1 = Station.new("example",1) #creates a station
> station2 = Station.new("example2",2)
> card.touch_in(station1) #touches in at a station
> card.touch_out(station2) #touches out at a station
> card.incomplete_journey #registers an incomplete journey
> card.journey_log.journeys #view journey history
```

Approach
---------
I started the challenge by creating an Oystercard class and followed the test-driven development process using Rspec to build out methods to support the user stories.  This class started out with responsibility for maintaining the balance, touching in and out and recording the journey history.  In order to better adhere to the Single Responsibility principle, I extracted a Journey class to record the start and end of the journey as well as calculate the fare.  I then extracted a JourneyLog class to store the journey history and handle interactions with the Journey class.  Now, Oystercard only has responsibility for maintaining the card balance.  At this point, the Journey class could calculate a minimum fare and a penalty fare if a journey is incomplete (i.e. a user either did not touch or did not touch out).  In order to take into account fares for journeys across different zones, a Station class was created to store information relating to a station i.e. its name and zone.  I then edited the fare calculation in the Journey class to add £1 for each zone travelled across.

The programme was further refactored to make use of dependency injection in the Oystercard and JourneyLog classes to reduce dependency on the JourneyLog and Journey classes respectively.

Further Work
-------------
Extensions
