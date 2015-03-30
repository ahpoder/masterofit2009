# Introduction #

On this page will be a combination of suggestions and solutions for Exercise 2.

# AHP #

## Format ##

As we already have SysML, I think it would be silly to invent other notations than what it offers. For the pure software part we naturally use UML, just like SysML suggestes.

There are a few areaswhere I think SysML is lacking.

  1. The Requirements diagrams are a mess, and a simple table of non-functionel requirements combined with Use-cases for functional requirements are better. One can still reference the requirements via their IDs from SysML, so we do not loos anything.
  1. Timing in SysML is a vague, and a suggest using the known diagrams in aslightly different way.
    1. Using the sequence diagram as a timing diagram. In the article "A HW/SW Codesign methodology based on UML" they have a totally non-standard drawing inside the component diagram. I do not think this is a good solution, even though the timing diagram is very well know. If we take the sequence diagram and place a vertical timeline on the left or right side we can express Hard real-time deadlines. For frequencies and such the Internal block diagram can be used, as it specifies interfaces and frequencies (as in serial baud rate) is always on a block boundry, so we do not need to invent anything there. I am not 100% sure this is sufficient, but if it is not we can always stick a real timing diagram somewhere.

All in all very few changes is required to SysML, it is more a matter of selcting which parts to use.

As for the specific diagrams to use I would choose:

### Requirements ###
  * Use cases
  * Table of non-functional requirements.

### Overall analysis ###
  * Block diagram
  * First level internal block diagrams (not necesarrily details about interfaces)
  * Perhaps a few activity diagrams to show critical parth or vital functionality.
  * Maybe a overall deployment diagram to show location of the parts that have already been placed.
  * Possibly a package diagram or two to show logical division.

### Detailed analysis ###
  * Internal block diagram.
  * Sequence diagram for real-time requirements and interresting sequences.
  * State and activity diagrams where needed.
  * Class diagrams for software along with sequence, state, ...
  * Deployment diagram to show final physical layout.

## Process ##

As for the process naturally I would have chosen a Lean process utilizing Scrum with daily status meetings in the individual groups and weekly Scrum-master meetings between groups. However, as we are a distributed team I would suggest a slightly different approach. Also a Lean process, but with sub-division of assignments and peer reviews. Generally it is a good idea to assign responsibility of completion, so it is always know who is responsible for making sure something is completed, and on time (not that that person has to do the work, just that he is responsible for it being done). Furthermore it is reccomendable to have one person who monitors the progress, updates the time-table and flags if something is behind - this person naturally also work on the normal assignments, but it is good to have someone who has the big picture.

## Tools ##

I have never been a big fan of big heavy documentation tools. I find that you end up using enormous amounts of time finding ways to circumvent the system when you want to do something they had not thought of, or it just does not fit your system.

Therefore I would reccomend a simple Visio based approach. Doing the SysML diagrams by hand and writing the code after them. Naturally there is the risk that the documents are not updated when a design update happens during implementation, but here strong configuration management is essential. As we do not have to implement we can luckily skip this, and we only need configuration management to ensure that our individual design documents are in sync.

As for the documents themselves I suggest we simply create a Visio document our-selves and work from that. Then we have a maseter document where we copy all drawings to when they are done. Modifications to drawings in the master document should be done very carefully and only with general consensus. I suggest comitting su Subversion so we have a change log and also a safe place for the material. I suggest using emails for primary conversation and Skype for non-face-to-face meetings. Wiki may be used for listing progress and for general information, but should be in addition to an email.