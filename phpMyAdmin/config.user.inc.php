<?php
/**
 * phpMyAdmin configuration example for multiple databases
 * Place this file at: ${DIR}/config/config.user.inc.php
 */
// Server 1: Remote Production DB
$i = 1;
$cfg['Servers'][$i]['host'] = getenv('SERVER1_HOST');
$cfg['Servers'][$i]['port'] = getenv('SERVER1_PORT');
$cfg['Servers'][$i]['verbose'] = 'Remote Production DB';
$cfg['Servers'][$i]['auth_type'] = 'config';
$cfg['Servers'][$i]['ssl'] = true;
$cfg['Servers'][$i]['ssl_verify'] = false;  // Set to true if you have proper SSL certs
$cfg['Servers'][$i]['user'] = getenv('MYSQL_USER_REMOTE');
$cfg['Servers'][$i]['password'] = getenv('MYSQL_PASSWORD_REMOTE');

// Server 2: Local Production DB # 1
$i++;
$cfg['Servers'][$i]['host'] = getenv('SERVER2_HOST');
$cfg['Servers'][$i]['port'] = getenv('SERVER2_PORT');
$cfg['Servers'][$i]['verbose'] = 'Local Production DB # 1';
$cfg['Servers'][$i]['auth_type'] = 'config';
$cfg['Servers'][$i]['user'] = getenv('MYSQL_USER_L1');
$cfg['Servers'][$i]['password'] = getenv('MYSQL_PASSWORD_L1');

// Server 3: Local Dev DB # 2
$i++;
$cfg['Servers'][$i]['host'] = getenv('SERVER3_HOST');
$cfg['Servers'][$i]['port'] = getenv('SERVER3_PORT');
$cfg['Servers'][$i]['verbose'] = 'Local Dev DB # 2';
$cfg['Servers'][$i]['auth_type'] = 'config';
$cfg['Servers'][$i]['user'] = getenv('MYSQL_USER_L2');
$cfg['Servers'][$i]['password'] = getenv('MYSQL_PASSWORD_L2');


// General settings
$cfg['LoginCookieValidity'] = 3600;  // Session timeout in seconds
$cfg['AllowArbitraryServer'] = true;  // Allow users to specify custom server
$cfg['DefaultLang'] = 'en';
$cfg['ServerDefault'] = 1;  // Default server on login page

?>
