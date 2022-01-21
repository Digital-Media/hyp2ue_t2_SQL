# hyp2ue_t2_SQL

## Installation

See [Installation](https://github.com/Digital-Media/hyp2ue_t2_SQL/INSTALL.md)

## Install or Restore onlineshop with Docker

```shell
docker exec -it mariadb /bin/bash -c "mariadb -uonlineshop -pgeheim </src/onlineshop.sql"
```

## Execises

Goal of the three lessons is to learn SQL. We start with DDL und focus on DML in the second part. 
Part three deals with normal forms and ER models. 
To edit SQL-Statements you can use any text editor, but I would recommend using PHPStorm with its DataGrip plugin.
The database is installed in a Virtual Box Image and maintained with Vagrant.
For details of Troubleshooting and Basics of virtualization see [Vagrant Installation](https://github.com/Digital-Media/fhooe-webdev/blob/master/README.md) and its [Troubleshooting Guide](https://github.com/Digital-Media/fhooe-webdev/wiki)

Besides DataGrip you can use PHPMyAdmin, MySQLWorkbench and many other Tools for database administration to run SQL-Scripts.
But PHPStorm provides a full integration of all technologies we need to use SQL in a web application.

As an prerequisite you can get onlineshop.sql as gist:

Get [onlineshop.sql](https://gist.github.com/martinharrer/846dbd667e35ba8ccbe04bd96b1aadd3)

Use
```shell
wget https://gist.githubusercontent.com/martinharrer/846dbd667e35ba8ccbe04bd96b1aadd3/raw/8a0be492bd21dc6c904b4e42e3ff17d684b8978f/onlineshop.sql
``` 
to get it in a commandline.

Open a PowerShell or a Terminal on MAC and go to the directory, where your Vagrantfile ist stored:
`cd <path-to>/fhooe-webdev`
and start the Virtual Box Image with
`vagrant up`.

Open the Projekt hypue2-t2-SQL in PHPStorm. Press the right mouse button and choose run onlineshop.sql.
Choose the preconfigured MariaDB-Connection. If that works you can start. Otherwise check your [Configuration 
of the database connection](https://github.com/Digital-Media/hyp2ue-t2-SQL/blob/main/InstallWebdevelopmentEnvironment.pdf).

Alternatively you can import the script onlineshop.sql with PHPMyAdmin. Open https://192.168.7.7/phpmyadmin in a browser.
Login with onlineshop/geheim and go to the tab import.

A third option is to do this in a commandline. With the provided Vagrant image, the steps below are necessary.

```shell
vagrant ssh
cd /var/www/html/code/hyp2ue-t2-SQL
sudo bash
mariadb
```
```shell
MariaDB [(none)]> \. onlineshop.sql
```

Each step of the lessons should be marked with a comment like this:

```shell
-- 1
```

Use multiline comments to answer questions within the SQL file:

```shell
/*
 You need the blank '-- ' to make it an SQL comment
 not writing the blank --causes a syntax error
*/
```

## part 1 DDL 

Use `sql/login.sql` as a starting point.

1.  Create a table with an appropriate name
* it should contain the columns `email`, `password` and `active`.
* Add an appropriate primary key (`BIGINT`, `UNSIGNED` and `AUTOINCREMENT`)
* All columns are required fields.
* `active` will contain a MD5 hash.  
* Use appropriate data types and length
* What could be the point of saving this table in an additional database outside `onlineshop`
2. Create a table with 6 columns
* A primary key with `BIGINT UNSIGNED AUTOINCREMENT`, a `TEXT` column, a `VARCHAR`, a `DATE`, a `DECIMAL` and a column, 
  that will become a foreign key.
* Choose column names that make sense together with the data type.
* All columns are required fields.
* Consider adding an index (`KEY`) to the column that will become foreign key.
* Add a foreign key to the chosen column in an additional statement and connect the current table 
with the one from step 1.
3. Add 5 rows to each of the tables above.
* Use all 3 types of `insert` to do this.
* Use appropriate, fictional values for each column.
* Use MD5(RAND(1)) for the column active to hash the value of a randomized seed.
* Look into MariaDB documentation to find possible encryption functions for the password.
Do you think MariaDB provides functions, that are secure enough? 
  Which functions does PHP provide to encrypt and verify passwords?
4. Delete the content of the tables in the right order
* PK, FK order?
* Use two different kind of statements to do this.
5. Delete the tables itself in the right order
6. Do some research on "[dynamic columns](https://mariadb.com/kb/en/dynamic-columns/)"
* Consider which tables of the onlineshop schema are candidates to use dynamic columns.
* Create an example table, that makes use of dynamic columns. Not the one from the MariaDB documentation!
That will give 0 points for this step.
* JSON is already used here. Read the data in JSON format. Where does JSON come from?
* Delete the table created for the dynamic column example.

The Script created for this exercise should run without errors.
For example:
```shell
user@ubuntu1/mycode$ sudo mysql –uonlineshop –pgeheim <login.sql
```
`item_name       COLUMN_JSON(dynamic_cols)`\
`MariaDB T-shirt {"size":"XL","color":"blue"}`\
`Thinkpad Laptop {"color":"black","price":500}`

But you can use DataGrip/PHPStorm or PHPMyAdmin as well.

## part 2 DML

Use `sql/ue2.sql` as a starting point. See if you can run the script with clicking the right mouse button and choose run `ue2.sql`.
Otherwise check your [Configuration of the database connection](https://github.com/Digital-Media/hyp2ue-t2-SQL/blob/main/InstallWebdevelopmentEnvironment.pdf).

If you need content for inserting, updating or comparing values look into the tables already provided in the `onlineshop` schema.
For example: `insert into user set email = 'shopuser1@onlineshop.at'`. Although this is commonly used you do not have to
capitalize reserved words. Syntax highlighting in modern editors has the same effect.

1. Write an SQL statement to insert a data row in `onlineshop.user`
* Make use of the `AUTOINCREMENT` on the column `iduser`.
* Use `now()` for the date value.
* For the column `active` use `MD5(RAND(<number> | <string>))`. This hash is used for two-phase authentification.
Therefore an email is sent to the user with a link containing the hash value stored in `active`: www.maindomain.org?active=hash. 
If the user clicks this link a program on the server compares the sent hash with the database and sets `active` to null.
Only then the authentification is valid and the registration finished.
* The column `role`  has a default value. If you need other values like `'admin'` you have to add this column to the
insert statement.
* For`password` you can use a plain string. Later we will use a hash value generated by the PHP function `password_hash()`.  

2. Write an SQL statement that checks if a combination of a password and an email is already stored in the database, and
if the account is already activated.
* In the `select` clause use `iduser`, `first_name`, `last_name` and `nick_name`.
* Compare `onlineshop.user.password` with a plain string. Embedded in PHP we will use the function `password_verify()` to do this. 
Then `password` has to be part of the `select` clause.
* `active` has to be compared as follows: `active is null`
* These are the three constraints for a valid login to OnlineShop.

3. Set an appropriate value for `onlineshop.product.product_category_name` for all products already stored.
* Which kind of statement can do the job?
* Have a look at `onlineshop.product_category.product_category_name` to find appropriate values.
* Write 5 or 2 Statements to change the values.
* You need not bring it down to one statement using subselects and wildcards or `case`.

4. Write a statement that adds a new data row to `onlineshop.product`.
* `product_category_name` should be 'Wohnung'.
* Make use of the `AUTOINCREMENT`  on `idproduct`.
* Use now() for the date.
* Set `active` to 1. That means the product should be listed on the website.
* For all other columns use values that make sense.

5. Write an SQL statement that copies data from `onlineshop.cart` to `onlineshop.orders` and `onlineshop.order_item`.
This two statements build the step final checkout or `order with costs`.
* See [SQL_exercise_part2.pdf](https://github.com/Digital-Media/hyp2ue-t2-SQL/blob/main/SQL_exercise_part2.pdf) for an ER-Modell.
* Use two types of subselects for this.
* Which insert has to be the first one, considering that`order_item.orders_idorders` is a foreign key
pointing at `orders.idorders`?
* For one order always group data rows together that have the same `session_id`.
* Instead of a value for total_sum use a subselect on the right position within the statement.
`insert into orders ( ..., total_sum, ...) values ( ..., select that returns only one value, ...)`
* For `order_item` use a subselect to transfer all entries from `cart`. For each column in the
table description of order_item set an appropriate column in the select clause in the right order.
* `cart.orders_idorders` can be filled with `last_insert_id()`.
* Consider, that you will need on statement for each `session_id`
* `cart` is an inMemory table. Therefore it is emptied at every reboot.
To get test data, see [onlineshop.sql](https://github.com/Digital-Media/hyp2ue-t2-SQL/blob/main/onlineshop.sql)

6. Write a statement that lists all turnovers grouped by product category.
* Use a join between `order_item` and `product` to handle this.
* This is a step towards data warehouse. Data warehouses are database instances that are optimized for read performance
and data aggregation jobs.
* Add a `having` clause to limit the result set to data rows with a turnover less than 100000 €.  

To test your script run `onlineshop.sql` before `ue2.sql`. Both scripts must not return errors.
You can use PHPStorm/DataGrip and run for this. 
You can use PHPMyAdmin/Import or the commandline as well.
```shell
cd <path-to-onlineshop.sql>
sudo bash
mariadb
[MariaDB (none)] \. onlineshop.sql
[MariaDB (none)] \. ue2.sql
```

## part 3 normal forms and ER models

Create a new file with an arbitrary name `<mysolutionfilename>.sql` in the sql folder. The extension has to be `.sql`.
This file should transfer the original [data model](https://github.com/Digital-Media/hyp2ue_t2_SQL/blob/main/pictures/onlineshop_alternate.png)
created by [onlineshop.sql](https://github.com/Digital-Media/hyp2ue_t2_SQL/blob/main/sql/onlineshop.sql)
into the data model given by the steps of this exercise.

To generate a visualization of the data model goto PHPStorms DataGrip Widget after running `onlineshop.sql`.
[PHPStorm ER Diagram Visualization](https://github.com/Digital-Media/hyp2ue_t2_SQL/blob/main/pictures/ERDiagramsPHPStorm.png)
* Click Database in the right upper corner
* Right click on onlineshop
* Click on Diagrams at the end of the list
* Click Show Visualization

There are two ways, how you can handle this. 
1. Copy onlineshop.sql and alter the original statements in a way that the new data model is created.
2. Run onlineshop.sql and afterwards run the new script containing alter table statements that change the physical model.

The former script is used to build a new installation script for a new digital product or a new version of it.
The later script is used to change a data model already used in production to add new features or delete
unnecessary features.

All tables are in 1NF unless otherwise stated.

In this exercise we will focus on the second scenario with alter table statements.

1. Have a look at the data model and see which tables already meet 2NF or not.
* Which tables meet 1NF at the first glance? Give a rationale for this.
* Which tables need a closer look to decide on this?
* Give a rationale for each of these tables, why they meet 2NF or not.

2. Have a look at the tables `address`, `city` and `country`. Explain, why the CHASM trap exists in this case 
or why it does not. A relevant question is a query for all address fields.
   
3. Have a look at the tables `order`, `user` and `visit`. Explain, why the FAN trap exists in this case 
or why it does not. A relevant question is a query that asks at which visit the order was placed.

4. Look at the table address. Does it meet 1NF, if it is necessary to ask for street, house number, 
door number and floor directly? Change the table address in a way that it meets this new requirements.
   
5. address meets 3NF in both cases, because the columns of `city` and `country` are in separate tables.
Change `address` in a way that querying the whole address becomes faster. `city` and `country` should remain
as lookup tables. Give reasons for using lookup tables and how they are used in web development.
   
6. Change the tables `product` and `product_category` in a way that they meet 3NF.

7. Look at the table `payment`. Three columns do not have speaking names. Change the data model in a way
that you know, what is stored in a special column. Although think of solutions to store as many attributes for different
payment variants as necessary. Implement 3 variants discussed in the database script. Each payment table 
should be linked to the table `user` in a proper way. 
   
8. Rework the table `order` in a way that the columns for payment match one of the 3 variants of 7.

9. Create a new table `user_visit` based on the columns of `user` and `visit` (CREATE TABLE .. AS SELECT + JOIN).
Which problems will you face it the tables `user` and `visit` would no longer exist? What happens, when user login.
How do people change their password, emails, try to login or register? How is this stored in this case? 
What information can be queried from the new table (append only instead of updates) that has not been 
there, when the information was stored in `user` and updated later.   
