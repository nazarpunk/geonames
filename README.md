https://flaviocopes.com/mysql-how-to-install/
https://stackoverflow.com/questions/59993844/error-loading-local-data-is-disabled-this-must-be-enabled-on-both-the-client


```shell
sudo mysql --local_infile=1 -u root -p
```

```
select database geonames
load data local infile '~/Downloads/alternateNamesV2.txt' into table alternate_names
```


```
root
qwerty1Q
```

```shell
brew services start mysql 
```

```shell
brew services stop mysql
```

```shell
brew services restart mysql
```

```shell
mysql --help
```

```shell
touch  ~/.my.cnf
echo -n > ~/.my.cnf
echo "[mysqld]
secure-file-priv = ''
local_infile=1
[mysql]
local-infile=1 
[client]  
local_infile=1" >> ~/.my.cnf 
```

http://download.geonames.org/export/dump/
