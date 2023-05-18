#!/bin/bash

chmod +x /home/wso2/Downloads/Automating-Product-Migration-Testing/3-utils/mysql.sql
docker exec -i mysql_eight sh -c 'exec mysql -uroot -proot' < /home/wso2/Downloads/Automating-Product-Migration-Testing/3-utils/mysql.sql
echo "Database created successfully!!"

chmod +x /home/wso2/Downloads/Automating-Product-Migration-Testing/3-utils/dbscripts/mysql.sql
docker exec -i mysql_eight sh -c 'exec mysql -uroot -proot -D '$DATABASE'' < /home/wso2/Downloads/Automating-Product-Migration-Testing/3-utils/dbscripts/mysql.sql
docker exec -i mysql_eight sh -c 'exec mysql -uroot -proot -D '$DATABASE'' < /home/wso2/Downloads/Automating-Product-Migration-Testing/3-utils/dbscripts/identity/mysql.sql
docker exec -i mysql_eight sh -c 'exec mysql -uroot -proot -D '$DATABASE'' < /home/wso2/Downloads/Automating-Product-Migration-Testing/3-utils/dbscripts/identity/uma/mysql.sql
docker exec -i mysql_eight sh -c 'exec mysql -uroot -proot -D '$DATABASE'' < /home/wso2/Downloads/Automating-Product-Migration-Testing/3-utils/dbscripts/consent/mysql.sql
docker exec -i mysql_eight sh -c 'exec mysql -uroot -proot -D '$DATABASE'' < /home/wso2/Downloads/Automating-Product-Migration-Testing/3-utils/dbscripts/metrics/mysql.sql
