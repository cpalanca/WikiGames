create database wikigames default character set utf8 collate utf8_unicode_ci;                                                                                                                                                             
create user ugames@localhost identified with mysql_native_password by 'cgames';                                                                                                                                                           
grant all on wikigames.* to ugames@localhost;                                                                                                                                                                                             
flush privileges;
quit;
