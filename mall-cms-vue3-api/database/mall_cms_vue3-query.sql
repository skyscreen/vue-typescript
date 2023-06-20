CREATE DATABASE mall_cms_vue3;

CREATE TABLE IF NOT EXISTS users (
  id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(30) NOT NULL UNIQUE,
	realname VARCHAR(20) NOT NULL,
	password VARCHAR(255) NOT NULL,
	cellphone BIGINT NOT NULL,
	enable INT NOT NULL,
	departmentId INT,
	roleId INT,
	avatarUrl VARCHAR(255),
	createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS department (
  id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(20) NOT NULL UNIQUE,
	leader VARCHAR(30),
	parentId INT,
	createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

	FOREIGN KEY (leader) REFERENCES users(name) ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (parentId) REFERENCES department(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS role (
  id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(20) NOT NULL UNIQUE,
	intro VARCHAR(255),
	createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

ALTER TABLE users ADD FOREIGN KEY(departmentId) REFERENCES department(id) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE users ADD FOREIGN KEY(roleId) REFERENCES role(id) ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE IF NOT EXISTS menu (
  id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(20) NOT NULL UNIQUE,
	type INT NOT NULL,
	icon VARCHAR(255),
	url VARCHAR(255) UNIQUE,
	sort INT,
	permission VARCHAR(255),
	parentId INT,
	createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	FOREIGN KEY (parentId) REFERENCES menu(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS role_menu (
  id INT PRIMARY KEY AUTO_INCREMENT,
	roleId INT NOT NULL,
	menuId INT NOT NULL,
	createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	FOREIGN KEY (roleId) REFERENCES role(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (menuId) REFERENCES menu(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS avatar (
  id INT PRIMARY KEY AUTO_INCREMENT,
	filename VARCHAR(255) NOT NULL,
	mimetype VARCHAR(30) NOT NULL,
	size BIGINT NOT NULL,
	userId INT NOT NULL,
	createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS category (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(20) NOT NULL UNIQUE,
	createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS goods (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(100) NOT NULL,
	oldPrice BIGINT,
	newPrice BIGINT NOT NULL,
	description VARCHAR(255) NOT NULL,
	enable INT NOT NULL,
	imgUrl VARCHAR(255) NOT NULL,
	inventoryCount BIGINT NOT NULL,
	saleCount BIGINT NOT NULL,
	favorCount BIGINT NOT NULL,
	address VARCHAR(255) NOT NULL,
 	createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS goods_category (
	id INT PRIMARY KEY AUTO_INCREMENT,
	goodsId INT NOT NULL,
	categoryId INT NOT NULL,
	createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	FOREIGN KEY (goodsId) REFERENCES goods(id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (categoryId) REFERENCES category(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS moment (
	id INT PRIMARY KEY AUTO_INCREMENT,
	title VARCHAR(20) NOT NULL,  
	contentHtml TEXT NOT NULL,
	contentText TEXT NOT NULL,
	userId INT NOT NULL,
	createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
)




SELECT
 	g.id, g.name, g.oldPrice, g.newPrice, g.description, g.enable,
  g.imgUrl, g.inventoryCount, g.saleCount, g.favorCount, g.address,
  JSON_ARRAYAGG(c.name) category, g.createAt, g.updateAt
FROM goods g
LEFT JOIN goods_category gc ON gc.goodsId = g.id
LEFT JOIN category c ON c.id = gc.categoryId
WHERE g.id = 1;


SELECT 
	g.id, g.name, g.oldPrice, g.newPrice, g.description, g.enable,g.imgUrl, 
	g.inventoryCount, g.saleCount, g.favorCount, g.address, g.createAt, g.updateAt,
	JSON_ARRAYAGG(c.name) category
FROM goods g
LEFT JOIN goods_category gc ON gc.goodsId = g.id
LEFT JOIN category c ON c.id = gc.categoryId
WHERE g.name LIKE '%秋%'
GROUP BY g.id
LIMIT 0, 10;


SELECT 
	SUM(inventoryCount) inventory, SUM(saleCount) sale, SUM(favorCount) favor
FROM goods;


SELECT 
	c.id, c.name, COUNT(gc.goodsId) goodsCount
FROM category c
LEFT JOIN goods_category gc ON gc.categoryId = c.id
GROUP BY c.id;


SELECT 
	c.id, c.name, SUM(g.saleCount) saleCount
FROM category c
LEFT JOIN goods_category gc ON gc.categoryId = c.id
LEFT JOIN goods g ON g.id = gc.goodsId
GROUP BY c.id;


SELECT
  address, SUM(saleCount) count
FROM goods
GROUP BY goods.address;




























