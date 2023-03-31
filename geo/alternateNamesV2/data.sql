# fix
# @formatter:off

# Киевская область
delete from alternateNamesV2 where (id = 703446 and pk = 0) or pk in (5650369, 7841982, 7841983, 8556560, 8556563);

# Киев, Севастополь - особый статус
delete from allCountries where id in (703447,694422);
delete from alternateNamesV2 where id in(703447,694422);