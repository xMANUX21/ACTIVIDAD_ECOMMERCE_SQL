CREATE DATABASE IF NOT EXISTS ECOMMERCE;

USE ECOMMERCE;


CREATE TABLE categorias (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(50) NOT NULL,
  name VARCHAR(100) NOT NULL,
  active BOOLEAN DEFAULT TRUE
);


CREATE TABLE metodos_pago (
  id INT PRIMARY KEY AUTO_INCREMENT ,
  code VARCHAR(50) NOT NULL,
  name VARCHAR(100) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  amount INT NOT NULL CHECK (amount >= 1),
  active BOOLEAN DEFAULT TRUE
);


CREATE TABLE productos (
  id INT  PRIMARY KEY AUTO_INCREMENT ,
  code VARCHAR(50) NOT NULL,
  name VARCHAR(100) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  stock DECIMAL(10,2) NOT NULL,
  description TEXT,
  image VARCHAR(255),
  brand VARCHAR(100),
  CONDICION ENUM('new', 'old', 'renewed') NOT NULL,
  vat DECIMAL(5,2) NOT NULL,
  active BOOLEAN DEFAULT TRUE,
  category_id INT NOT NULL,
  FOREIGN KEY (category_id) REFERENCES categorias(id)
);


CREATE TABLE usuarios (
  id INT PRIMARY KEY AUTO_INCREMENT ,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL,
  identification_number VARCHAR(50) NOT NULL,
  user_type ENUM('A', 'S', 'C') NOT NULL, -- Administrador,Seller, Cliente
  identification_type ENUM('CC', 'CE', 'NI') NOT NULL,
  phone VARCHAR(30),
  password VARCHAR(255),
  active BOOLEAN DEFAULT TRUE,
  registered DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE lugares (
  id INT  PRIMARY KEY AUTO_INCREMENT,
  city VARCHAR(100),
  country VARCHAR(100),
  address VARCHAR(150),
  zip_code VARCHAR(10),
   usuario_id INT NOT NULL,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE ventas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  reference VARCHAR(50) NOT NULL,
  date DATETIME NOT NULL,
  payment_method_id INT NOT NULL,
  client_id INT NOT NULL,
  seller_id INT NOT NULL,
  FOREIGN KEY (payment_method_id) REFERENCES metodos_pago(id),
  FOREIGN KEY (client_id) REFERENCES usuarios(id),
  FOREIGN KEY (seller_id) REFERENCES usuarios(id)
);

CREATE TABLE detalle_venta (
  id INT  PRIMARY KEY AUTO_INCREMENT ,

  quantity INT NOT NULL CHECK (quantity >= 1),
  price DECIMAL(10,2) NOT NULL,
  venta_id INT NOT NULL,
  product_id INT NOT NULL,
  FOREIGN KEY (venta_id) REFERENCES ventas(id),
  FOREIGN KEY (product_id) REFERENCES productos(id)
);
-- Inserciones
INSERT INTO categorias (code, name, active) VALUES
('ELEC', 'Electrónica', TRUE),
('HOG', 'Hogar', TRUE),
('TEC', 'Tecnología', TRUE),
('HOG', 'Hogar', TRUE),
('MOD', 'Moda', TRUE);


INSERT INTO metodos_pago (code, name, price, amount, active) VALUES
('EFECT', 'Efectivo', 0.00, 1, TRUE),
('TARJ', 'Tarjeta de crédito', 500.00, 1, TRUE),
('EFEC', 'Efectivo', 0, 1, TRUE),
('TDC', 'Tarjeta de Crédito', 1000, 1, TRUE),
('NEQUI', 'Nequi', 500, 1, TRUE);


INSERT INTO usuarios (first_name, last_name, email, identification_number, user_type, identification_type, phone, password, active)
VALUES 
('Ana', 'Gómez', 'ana@example.com', '11223344', 'C', 'CC', '3001234567', 'clave123', TRUE),
('Luis', 'Torres', 'luis@example.com', '55667788', 'S', 'CE', '3017654321', 'clave456', TRUE),
('Ana', 'Martínez', 'ana.martinez@gmail.com', '10101010', 'C', 'CC', '3112345678', 'pass123', 'Bogotá', 'Colombia', 'Calle 123 #45-67', 110111, TRUE, NOW()),
('Luis', 'Gómez', 'luis.gomez@gmail.com', '20202020', 'S', 'CC', '3123456789', 'pass456', 'Medellín', 'Colombia', 'Cra 45 #67-89', 050001, TRUE, NOW()),
('Sofía', 'Ríos', 'sofia.rios@gmail.com', '30303030', 'A', 'CE', '3134567890', 'pass789', 'Cali', 'Colombia', 'Av 30 #10-50', 760001, TRUE, NOW());


INSERT INTO lugares (usuario_id, city, country, address, zip_code) VALUES
(1, 'Bogotá', 'Colombia', 'Cra 10 #20-30', '110111'),
(2, 'Medellín', 'Colombia', 'Cll 50 #40-20', '050010');


INSERT INTO productos (code, name, price, stock, description, image, brand, CONDICION, vat, category_id, active) VALUES
('TV001', 'Smart TV 55"', 2000.00, 10, 'TV Samsung 4K', 'https://example.com/tv.jpg', 'Samsung', 'new', 19.00, 1, TRUE),
('P001', 'Laptop Dell', 3200000, 10, 'Laptop core i5 8GB RAM', 'https://example.com/dell.jpg', 'Dell', 'new', TRUE, 1, 0.19),
('P002', 'Licuadora Oster', 230000, 20, 'Licuadora de alta potencia', 'https://example.com/oster.jpg', 'Oster', 'new', TRUE, 2, 0.19),
('P003', 'Camisa Hombre', 55000, 50, 'Camisa formal manga larga', 'https://example.com/camisa.jpg', 'Zara', 'new', TRUE, 3, 0.19);


INSERT INTO ventas (reference, date, payment_method_id, client_id, seller_id)
VALUES ('ORD001', NOW(), 1, 1, 2),('ORD002', NOW(), 1, 1, 2),('ORD1001', NOW(), 1, 1, 2),
('ORD1002', NOW(), 2, 1, 2),
('ORD1003', NOW(), 3, 1, 2);


INSERT INTO detalle_venta (venta_id, product_id, quantity, price)
VALUES (1, 1, 1, 2000.00),(1, 1, 1, 150.00),(1, 1, 1, 3200000),
(1, 2, 2, 230000),
(2, 3, 3, 55000),
(3, 1, 1, 3200000);

-- Indices
-- Indices sobre foraneas
CREATE INDEX idx_productos_categoria ON productos(category_id);
CREATE INDEX idx_ventas_cliente ON ventas(client_id);
CREATE INDEX idx_ventas_vendedor ON ventas(seller_id);
CREATE INDEX idx_ventas_metodo_pago ON ventas(payment_method_id);
CREATE INDEX idx_detalle_venta_venta ON detalle_venta(venta_id);
CREATE INDEX idx_detalle_venta_producto ON detalle_venta(product_id);
-- Indice por email
CREATE UNIQUE INDEX idx_usuarios_email ON usuarios(email);

-- Vistas

CREATE VIEW vista_inicio_sesion AS -- vista inicio de sesion de usuario
SELECT 
  u.email AS username,
  u.user_type AS rol,
  u.identification_number,
  u.identification_type,
  u.first_name,
  u.last_name,
  u.email,
  l.address,
  u.phone,
  l.city
FROM usuarios u
LEFT JOIN lugares l ON u.id = l.usuario_id;

SELECT * FROM vista_inicio_sesion;


CREATE VIEW vista_ordenes_usuario AS  -- vista de ordenes de usuarios
SELECT 
  v.reference,
  v.date,
  u.first_name,
  u.last_name,
  u.email,
  p.name AS producto,
  dv.quantity,
  dv.price,
  mp.name AS metodo_pago
FROM ventas v
JOIN usuarios u ON v.client_id = u.id
JOIN detalle_venta dv ON v.id = dv.venta_id
JOIN productos p ON dv.product_id = p.id
JOIN metodos_pago mp ON v.payment_method_id = mp.id;

SELECT * FROM vista_ordenes_usuario;

