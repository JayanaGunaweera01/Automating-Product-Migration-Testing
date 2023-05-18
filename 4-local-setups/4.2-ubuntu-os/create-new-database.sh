#!/bin/bash

chmod +x /home/wso2/Downloads/Automate-Product-Migration-Testing/utils/test.sql
docker exec -i mysql_eight sh -c 'exec mysql -uroot -proot' < /home/wso2/Downloads/Automate-Product-Migration-Testing/utils/test.sql
echo "Database created successfully!!"

chmod +x /home/wso2/Downloads/Automate-Product-Migration-Testing/utils/dbscripts/mysql.sql
docker exec -i mysql_eight sh -c 'exec mysql -uroot -proot -D '$DATABASE'' < /home/wso2/Downloads/Automate-Product-Migration-Testing/utils/dbscripts/mysql.sql
docker exec -i mysql_eight sh -c 'exec mysql -uroot -proot -D '$DATABASE'' < /home/wso2/Downloads/Automate-Product-Migration-Testing/utils/dbscripts/identity/mysql.sql
docker exec -i mysql_eight sh -c 'exec mysql -uroot -proot -D '$DATABASE'' < /home/wso2/Downloads/Automate-Product-Migration-Testing/utils/dbscripts/identity/uma/mysql.sql
docker exec -i mysql_eight sh -c 'exec mysql -uroot -proot -D '$DATABASE'' < /home/wso2/Downloads/Automate-Product-Migration-Testing/utils/dbscripts/consent/mysql.sql
docker exec -i mysql_eight sh -c 'exec mysql -uroot -proot -D '$DATABASE'' < /home/wso2/Downloads/Automate-Product-Migration-Testing/utils/dbscripts/metrics/mysql.sql
