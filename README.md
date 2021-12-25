# mysql8install

```shell
Usage: python /workspace/mysql8install/MySQL8install.py install [OPTION] [arg...]
Example:

            Simple: python mysql_install.py install --instance-ports=3366
            Multiple instances: python mysql_install.py install --instance-ports=3366,3399,4466


            If you know enough to the MySQL, you can use configure area:

            Simple: 

                python /workspace/mysql8install/MySQL8install.py install --instance-ports=3366 --innodb-buffer-pool-size=1G

            
install:
            custom  install:
                    --instance-ports            default:3306
                    --mysql-user                default:mysql
                    --base-prefix               default:/usr/local/mysql
                    --data-prefix               default:/data/db
```