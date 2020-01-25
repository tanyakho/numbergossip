
Locations of files:
- `uniqueWorking.txt` is located at: `db/properties`

-----------------------------
When I make changes, then first I can test it locally:

Starting local web server in the terminal in NG directory print:
rails server

Then in Firefox type
`localhost:(port number)`


after that I should run unit tests:
in terminal window in ng directory, type rails test


TODO(axch): New deployment instructions


go to numbergossip/status and push buttons if needed. Right now it tells that everything is out of date after the deploy because the time stamp changes. I do need to update the unique properties if I changed them.


`*.html.erb` files are in `app/views/number_gossip`
     do not need to push buttons, just check

To update credits, I have to go to app/controllers/number_gossip_controller and add there.




---------------------------------------
Moving Unique working to number_gossip directory on April 1, 2008

Sanity check - each line that is not empty should contain a colon:

```
grep " " uniqueWorking.txt|grep -v ";"
```

Each line that contains * corresponds to an approved property.
this can be checked with 
```
grep "^*" uniqueWorking.txt|wc
```
This checks lines that start with a `*`

- On May 28 2007 it was 752
- On Aug 28 2007 it was 782
- On Apr 1 2008 it was 839

In unique.txt the number of properties is counted in the following manner:
```
cat unique.txt | tr ";" "\n" | wc
```

`cat onefile` - outputs file; `tr` - replaces ; with a new line, then
we count the number of lines.

- On May 28 2007 it was 750.

Each line that contains ?? corresponds to a property I have to check.
this can be checked with
```
grep "??" uniqueWorking.txt | wc
```

- On May 15 2007 it was 666
- On Aug 28 2007 it was 740
- On April 1 2008 it was 674

Each line in `unique.txt` corresponds to a number with unique properties.
This can be checked with `wc unique.txt`

- On May 28 it was 463.
- On Aug 28 2007 it was 478.

