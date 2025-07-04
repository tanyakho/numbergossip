----------------------------------------
Locations of files

- `uniqueWorking.txt` is located at: `db/properties`
- `*.html.erb` files are in `app/views/number_gossip`
   do not need to push buttons, just check
- To update credits, I have to go to
  app/controllers/number_gossip_controller and add there.

---------------------------------------
Sanity checks

The uniqueWorking file should parse.  Can check this by running
```
bundle exec rake rebuild_database
```

Each line of uniqueWorking.txt that is not empty should contain a
colon:

```
grep " " uniqueWorking.txt|grep -v ";"
```

Each line that contains * corresponds to an approved property.
This can be checked with:

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
This can be checked with:

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

----------------------------------------
Deploy a static version of the site

- Quick test (Generate first 10 pages)
  bundle exec rake static:generate_test

- Test locally
  cd public/
  python3 -m http.server 8000
  browse http://localhost:8000

- Generate all pages (1-9999 + special pages) (as of 7/4/2025, this
  can take half an hour)
  bundle exec rake static:generate

- Generate specific range (including special pages)
  bundle exec rake static:generate_range[500,600]

- Clean up generated files
  bundle exec rake static:clean

- To upload to Github Pages, just git push; it will rebuild and deploy
  automatically.
