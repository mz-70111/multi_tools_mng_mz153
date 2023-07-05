import 'package:get/get.dart';
import 'package:mysql1/mysql1.dart';
import 'package:users_tasks_mz_153/controllers/databasecontroller0.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';

class DB {
  DBController dbController = Get.find();
  ConnectionSettings settings = ConnectionSettings(
      host: '127.0.0.1',
      port: 3306,
      user: 'mz',
      password: 'mzrootmz',
      db: 'mz_db',
      timeout: const Duration(seconds: 15));
  static List<Map> userstable = [],
      officetable = [],
      tasktable = [],
      todotable = [],
      usersOffice = [];
  createuserstable() async {
    MySqlConnection conn = await MySqlConnection.connect(settings);
    await conn.query(
        '''
create table if not exists users
(
user_id int(11) unique primary key auto_increment,
username varchar(255) unique,
fullname varchar(255) unique,
password varchar(255),
email varchar(255),
mobile varchar(255),
admin tinyint(1) default 0,
enable tinyint(1) default 1,
mustchgpass tinyint(1) default 1, 
addtodo tinyint(1) default 1,
addremind tinyint(1) default 0,
addping tinyint(1) default 0,
pbx tinyint(1) default 0
);
''');
    String cpassword = codepassword(word: 'admin');
    await conn.query(
        '''
insert into users(user_id,username,fullname,password,admin)values(1,'admin','admin','$cpassword',1);
''');
    await conn.close();
  }

  createofficetable() async {
    MySqlConnection conn = await MySqlConnection.connect(settings);
    await conn.query(
        '''
create table if not exists office
(
office_id int(11) unique primary key auto_increment,
officename varchar(255) unique,
chatid varchar(255),
notifi tinyint(1) default 0,
sendstatus tinyint(1) default 0,
color varchar(255)
);
''');
    await conn.close();
  }

  createusersofficetable() async {
    MySqlConnection conn = await MySqlConnection.connect(settings);
    await conn.query(
        '''
create table if not exists users_office
(
uf_id int(11) unique primary key auto_increment,
uf_user_id int(11),
foreign key (uf_user_id) references users(user_id),
uf_office_id int(11),
foreign key (uf_office_id) references office(office_id),
privilege varchar(255)
);
''');
    await conn.close();
  }

  createtaskstable() async {
    MySqlConnection conn = await MySqlConnection.connect(settings);
    await conn.query(
        '''
create table if not exists tasks
(
task_id int(11) unique primary key auto_increment,
taskname varchar(255) unique,
taskdetails varchar(255),
createby_id int(11),
createby varchar(255),
createdate TIMESTAMP NULL DEFAULT NULL,
editby_id int(11),
editby varchar(255),
editdate TIMESTAMP NULL DEFAULT NULL,
duration int(11),
extratime int(11) default 0,
status tinyint(1),
donedate TIMESTAMP NULL DEFAULT NULL,
foreign key (createby_id) references users(user_id),
foreign key (editby_id) references users(user_id),
notifi tinyint(1) default 1,
task_office_id int(11),
foreign key (task_office_id) references office(office_id)
);
''');
    await conn.close();
  }

  createuserstasktable() async {
    MySqlConnection conn = await MySqlConnection.connect(settings);
    await conn.query(
        '''
create table if not exists users_tasks
(
ut_id int(11) unique primary key auto_increment,
ut_user_id int(11),
foreign key (ut_user_id) references users(user_id),
ut_task_id int(11),
foreign key (ut_task_id) references tasks(task_id)
);
''');
    await conn.close();
  }

  createuserstasksCommentstable() async {
    MySqlConnection conn = await MySqlConnection.connect(settings);
    await conn.query(
        '''
create table if not exists users_tasks_comments
(
utc_id int(11) unique primary key auto_increment,
utc_user_id int(11),
foreign key (utc_user_id) references users(user_id),
utc_task_id int(11),
foreign key (utc_task_id) references tasks(task_id),
comments varchar(255),
commentdate TIMESTAMP  NULL DEFAULT NULL
);
''');
    await conn.close();
  }

  createtodotable() async {
    MySqlConnection conn = await MySqlConnection.connect(settings);
    await conn.query(
        '''
create table if not exists todo
(
todo_id int(11) unique primary key auto_increment,
todoname varchar(255) unique,
tododetails varchar(255),
createdate TIMESTAMP NULL DEFAULT NULL,
editdate TIMESTAMP NULL DEFAULT NULL,
todo_office_id int(11),
foreign key (todo_office_id) references office(office_id)
);
''');
    await conn.close();
  }

  createuserstodo() async {
    MySqlConnection conn = await MySqlConnection.connect(settings);
    await conn.query(
        '''
create table if not exists users_todo
(
utd_id int(11) unique primary key auto_increment,
createby_id int(11),
foreign key (createby_id) references users(user_id),
editby_id int(11),
foreign key (editby_id) references users(user_id),
utd_todo_id int(11),
foreign key (utd_todo_id) references todo(todo_id)
);
''');
    await conn.close();
  }

  createuserstodoCommentstable() async {
    MySqlConnection conn = await MySqlConnection.connect(settings);
    await conn.query(
        '''
create table if not exists users_todo_comments
(
utdc_id int(11) unique primary key auto_increment,
utdc_user_id int(11),
foreign key (utdc_user_id) references users(user_id),
utdc_todo_id int(11),
foreign key (utdc_todo_id) references todo(todo_id),
comments varchar(255),
commentdate TIMESTAMP  NULL DEFAULT NULL
);
''');
    await conn.close();
  }

  createuserstodoRatestable() async {
    MySqlConnection conn = await MySqlConnection.connect(settings);
    await conn.query(
        '''
create table if not exists users_todo_rates
(
utdr_id int(11) unique primary key auto_increment,
utdr_user_id int(11),
foreign key (utdr_user_id) references users(user_id),
utdr_todo_id int(11),
foreign key (utdr_todo_id) references todo(todo_id),
rates int(11)
);
''');
    await conn.close();
  }

  customquery({query}) async {
    MySqlConnection conn = await MySqlConnection.connect(settings);
    var t = await conn.query(query);
    await conn.close();
    return t;
  }

  createschedueldtable() async {
    MySqlConnection conn = await MySqlConnection.connect(settings);
    await conn.query(
        '''
create table if not exists sched
(
sched_id int(11) unique primary key auto_increment,
schedname varchar(255) unique,
scheddetails varchar(255),
notifigroup varchar(255),
notifi tinyint(1) default 1,
type varchar(255),
reminddate int
);
''');
    await conn.close();
  }

  createuserschedtable() async {
    MySqlConnection conn = await MySqlConnection.connect(settings);
    await conn.query(
        '''
create table if not exists users_sched
(
us_id int(11) unique primary key auto_increment,
us_usercreate_id int(11),
foreign key (us_usercreate_id) references users(user_id),
createdate TIMESTAMP  NULL DEFAULT NULL,
us_useredit_id int(11),
foreign key (us_useredit_id) references users(user_id),
editdate TIMESTAMP  NULL DEFAULT NULL,
us_sched_id int(11),
foreign key (us_sched_id) references sched(sched_id)
);
''');
    await conn.close();
  }

  createuserschedlogtable() async {
    MySqlConnection conn = await MySqlConnection.connect(settings);
    await conn.query(
        '''
create table if not exists users_sched_log
(
us_idlog int(11) unique primary key auto_increment,
us_user_idlog int(11),
foreign key (us_user_idlog) references users(user_id),
us_sched_idlog int(11),
foreign key (us_sched_idlog) references sched(sched_id),
comment varchar(255),
commentdate TIMESTAMP  NULL DEFAULT NULL,
remindlog varchar(255)
);
''');
    await conn.close();
  }
}
