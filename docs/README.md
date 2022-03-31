## qTest Manager Installation
After installation, there are basic configurations required for qTest applications to function.

### Change Client Site Name
Within PostgreSQL qTest Manager database
```
update clients set sitename='newname' where sitename='nephele';
update clients set name='newname' where name='Nephele';
```