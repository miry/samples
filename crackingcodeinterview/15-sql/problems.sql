/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

DROP DATABASE IF EXISTS cracking;
CREATE DATABASE cracking;

USE cracking;

CREATE TABLE apartaments
(
id INTEGER AUTO_INCREMENT,
unit VARCHAR(255) NOT NULL,
building_id INTEGER NOT NULL,
PRIMARY KEY (id),
CONSTRAINT `building_id_idxfk` FOREIGN KEY (`building_id`) REFERENCES `buildings` (`id`)
);

CREATE TABLE buildings
(
id INTEGER AUTO_INCREMENT,
name VARCHAR(255) NOT NULL,
address VARCHAR(255) NOT NULL,
complex_id INTEGER NOT NULL,
PRIMARY KEY (id),
CONSTRAINT `complex_id_idxfk` FOREIGN KEY (`complex_id`) REFERENCES `complexes` (`id`)
);

CREATE TABLE complexes
(
id INTEGER AUTO_INCREMENT,
name VARCHAR(255) NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE tenants
(
id INTEGER AUTO_INCREMENT,
name VARCHAR(255) NOT NULL,
PRIMARY KEY (id)
);

CREATE TABLE apartament_tenants
(
apartament_id INTEGER NOT NULL,
tenant_id INTEGER NOT NULL,
UNIQUE KEY `apartament_id_tenant_id_uniq` (`apartament_id`,`tenant_id`),
CONSTRAINT `apartament_id_idxfk` FOREIGN KEY (`apartament_id`) REFERENCES `apartaments` (`id`),
CONSTRAINT `tenant_id_idxfk` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`)
);

CREATE TABLE requests
(
id INTEGER AUTO_INCREMENT,
status VARCHAR(255) NOT NULL,
apartament_id INTEGER NOT NULL,
description VARCHAR(255) NOT NULL DEFAULT '',
PRIMARY KEY (id),
KEY `requests_apartament_id_idxfk` (`apartament_id`),
CONSTRAINT `requests_apartament_id_idxfk` FOREIGN KEY (`apartament_id`) REFERENCES `apartaments` (`id`)
);

/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;

insert into tenants(name) VALUES
 ("Jordan")
 ,("Luis")
 ,("Joahn")
 ;

insert into complexes(name) VALUES
 ("New York")
 ,("Britain London")
 ;

insert into buildings(name, address, complex_id) VALUES
 ("5th", "5th New York", 1)
 ,("6th", "6th New York", 1)
 ,("Nebo", "Britain", 2)
 ;

insert into apartaments(unit, building_id) VALUES
 ("1A", 1)
 ,("1B", 1)
 ,("1C", 1)
 ,("1D", 1)
 ,("1A", 2)
 ,("1B", 3)
 ;

insert into apartament_tenants(tenant_id, apartament_id) VALUES
 (1, 1)
 ,(1, 2)
 ,(2, 1)
 ;


insert into requests(apartament_id, status) VALUES
  (1, "open"),
  (2, "close"),
  (5, "open"),
  (6, "close")
  ;

select t.id, t.name, count(at.apartament_id) aps
from tenants t
  LEFT join apartament_tenants at on t.id = at.tenant_id
group by t.id
having aps > 1
;

-- Show number of open request per building
select b.id, b.name, count(r.id)
from buildings b
  left join apartaments a ON b.id = a.building_id
  left join requests r ON a.id = r.apartament_id and r.status='open'
group by b.id;

-- close all request for building
update requests r, apartaments a SET r.status = 'close' where r.status='open' and a.id = r.apartament_id and a.building_id=2;

-- Show number of open request per building after update
select b.id, b.name, count(r.id)
from buildings b
  left join apartaments a ON b.id = a.building_id
  left join requests r ON a.id = r.apartament_id and r.status='open'
group by b.id;
