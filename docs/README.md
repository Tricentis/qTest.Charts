## qTest Manager Installation
After installation, there are basic configurations required for qTest applications to function.

## Configure PostgreSQL in qTest Manager DB
### Change Client Site Name
Configurations to be completed within the PSQL interactive shell
```
update clients set sitename='newname' where sitename='nephele';
update clients set name='newname' where name='Nephele';
```