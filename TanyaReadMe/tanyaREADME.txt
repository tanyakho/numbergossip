
 Bump nokogiri 


Alexey Radul 
Sun, Mar 3 at 8:22 AM
If you want to handle these yourself, the procedure is:

1. [Optional] Push current work to Github minimize probability of getting confused later.
2. [Optional] Check what the request consists of, if you want. (follow the link to github at the bottom)
3. Log on to Github and merge the pull request (there's a big green "merge" button, and then you have to "confirm merge".
4. Pull.
5. [Optional] Confirm that the system still works. (locally. or check it after deploy)
6. Deploy. (can deploy later)
====================================================================

Script to open Firefox pages.  First argument is the number to start with; second argument is how many numbers' worth of sequences to open at once.  The second argument is optional, defaults to 1.

oeis2ng 90001 10000

The command in a terminal to search for sequences that start with a particular number. Just replace 238 with the number. It opens one Firefox page per sequence.

for name in `grep -E " .347," /home/tanya/Research/OEIS/ParsingOEIS/stripped | cut -d ' ' -f 1`; do firefox https://oeis.org/search?q=id:$name; done



How to search for sequences that start with large numbers.: 
seq:123 -seq:0 -seq:1 -seq:2 -seq:3 -seq:4 -seq:5 -seq:6 -seq:7 -seq:8 -seq:9 -seq:10 -seq:11 -seq:12 -seq:13 -seq:14 -seq:15 -seq:16 -seq:17 -seq:18 -seq:19 -seq:20 -seq:21 -seq:22 -seq:23 -seq:24 -seq:25 -seq:26 -seq:27 -seq:28 -seq:29 -seq:30 -seq:31 -seq:32 -seq:33 -seq:34 -seq:35 -seq:36 -seq:37 -seq:38 -seq:39 -seq:40 -seq:41 -seq:42 -seq:43 -seq:44 -seq:45 -seq:46 -seq:47 -seq:48 -seq:49 -seq:50 -seq:51 -seq:52 -seq:53 -seq:54 -seq:55 -seq:56 -seq:57 -seq:58 -seq:59 -seq:60 -seq:61 -seq:62 -seq:63 -seq:64 -seq:65 -seq:66 -seq:67 -seq:68 -seq:69 -seq:70 -seq:71 -seq:72 -seq:73 -seq:74 -seq:75 -seq:76 -seq:77 -seq:78 -seq:79 -seq:80 -seq:81 -seq:82 -seq:83 -seq:84 -seq:85 -seq:86 -seq:87 -seq:88 -seq:89 -seq:90 -seq:91 -seq:92 -seq:93 -seq:94 -seq:95 -seq:96 -seq:97 -seq:98 -seq:99 -seq:100 -seq:101 -seq:102 -seq:103 -seq:104 -seq:105 -seq:106 -seq:107 -seq:108 -seq:109 -seq:110 -seq:111 -seq:112 -seq:113 -seq:114 -seq:115 -seq:116 -seq:117 -seq:118 -seq:119 -seq:120 -seq:121



---------------------------------------------

How to run the local version of numbergossip.
oeis2ng 511 10
Need to run a server:
go to number_gossip directory in the terminal:
bundle exec rails server
If it says that the port is already in use, give an explicit port number e.g.:
bundle exec rails server -p 3007

Next I need to open a web browser
in the url I need to write localhost:3000 (or whatever port number is, for example 3007 above)


Changing css:
Go to number_gossip/public/stylesheets
Open any css file.





At the end I shouldn't forget to check in (TODO)
and to stop the server (by pressing Ctrl+C in the terminal).


======================================================
Standard flow to upload new unique properties.

Go to the directory numbergossip.

git status
If it is clean then
	git pull
else 
	git commit -a -m "changed web.yml to point to the new build" (The difference between those two (using -a and not) is that the `-a` stands for `git add`.  The idea is that you can break up one pile of changes into multiple commits if you wish, so `git commit` only commits the changes you have explicitly staged using `git add`.  However, since you often want to commit everything you changed, `git commit -a` first stages all the changes you have made to all files git is tracking (but not new ones), and then commits.)

git push (this pushes my changes to the github, so all my collaborators see them). The changes will be on the website after a delay of up to 30 minutes.




========================================================
------------------------------------------------------

GIT stuff, general

The directory www.tanyakhovanova.com/number_gossip is git repository.

It is a good idea each time I go here to start with "git status" command. This command doesn't talk to the Internet and only look locally.

If I am behind a commit, then I do "git pull" which is git fetch followed by git merge.

"git diff" allows me to compare my working copy of files with my my local copy of the history. "q" allows me to escape the command.

------------------------------------------

When I update the files.

Before updating I can check for sanity by running
bundle exec rails test

"git status"

First I need to commit, which is a local operation that saves my changes to my local git history. I need to say what to commit.

"git commit -a -m "message about what is changed"" commit all changes to all files git knows about.

Then I need to push to the git repository

"git push"

In case it is not accepted I might need

"git pull"
-------------------------------------





"git fetch" I rare need to use it by itself.

"git merge" I rare need to use it by itself.


--------------------------------------------------
=====================================================

Checking the results of Deploy

refreshing the cache for a site: 
Ctrl-Shift-R in Firefox.
===============================================================

Sanity checking

The uniqueWorking file should parse.  Can check this by running
```
bundle exec rake rebuild_database
```

Data dump from numbergossip:
https://www.ask-math.com/UniqueNumbers.html

