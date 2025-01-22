CREATE DATABASE BDmmo;

USE BDmmo;

CREATE TABLE Amigos (
    id_amigo INT AUTO_INCREMENT PRIMARY KEY,
    id_jugador1 INT NOT NULL,
    id_jugador2 INT NOT NULL,
    estado ENUM('Pendiente', 'Aceptado', 'Bloqueado') DEFAULT 'Pendiente',
    fecha_amistad TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (id_jugador1, id_jugador2),
    FOREIGN KEY (id_jugador1) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_jugador2) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE Party (
    id_party INT AUTO_INCREMENT PRIMARY KEY,
    id_lider_party INT NOT NULL,
    nivel_promedio INT,
    fecha_creacion DATE
);

CREATE TABLE Clanes (
    id_clan INT AUTO_INCREMENT PRIMARY KEY,
    id_lider_clan INT NOT NULL,
    nombre_clan VARCHAR(50),
    nivel_clan INT,
    fecha_fundacion DATE
);

CREATE TABLE Combates (
    id_combate INT AUTO_INCREMENT PRIMARY KEY,
    id_participante1 INT NOT NULL,
    id_participante2 INT,  -- Puede ser NULL si es PvE
    id_enemigo INT,        -- Se usa si es un combate contra NPC
    ganador INT NOT NULL,
    duracion_segundos INT,
    fecha_combate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_participante1) REFERENCES Personajes(id_personaje),
    FOREIGN KEY (id_participante2) REFERENCES Personajes(id_personaje),
    FOREIGN KEY (id_enemigo) REFERENCES Enemigos(id_enemigo)
);

CREATE TABLE Reportes (
    id_reporte INT AUTO_INCREMENT PRIMARY KEY,
    id_jugador_reportado INT NOT NULL,
    id_reportador INT NOT NULL,
    motivo_reportado VARCHAR(250),
    fecha_reporte DATE
);

CREATE TABLE Chat (
    id_chat INT AUTO_INCREMENT PRIMARY KEY,
    id_jugador INT NOT NULL,
    mensaje_chat VARCHAR(2000),
    fecha_hora TIMESTAMP
);

CREATE TABLE Servidor (
    id_servidor INT AUTO_INCREMENT PRIMARY KEY,
    nombre_servidor VARCHAR(50),
    pais_conexion VARCHAR(50),
    max_jugadores INT,
    latencia_promedio FLOAT
);

CREATE TABLE LeaderBoard (
    id_top INT AUTO_INCREMENT PRIMARY KEY,
    max_kills INT,
    max_curacion INT,
    cantidad_raids INT,
    cantidad_muertes INT,
    id_jugador INT NOT NULL
);

CREATE TABLE RolesClan (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR(50),
    permisos_rol VARCHAR(250),
    id_clan INT NOT NULL,
    FOREIGN KEY (id_clan) REFERENCES Clanes(id_clan)
);

CREATE TABLE Raids (
    id_raid INT AUTO_INCREMENT PRIMARY KEY,
    nombre_raid VARCHAR(50),
    nivel_requerido INT,
    recompensa_raid VARCHAR(250),
    duracion_estimada TIME
);

-- Usuario
CREATE TABLE Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(30),
    telefono_usuario VARCHAR(30),
    correo_usuario VARCHAR(50),
    fecha_nacimiento DATE,
    pais_usuario VARCHAR(50)
);

CREATE TABLE ConfiguracionUsuario (
    id_configuracion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    notificaciones_activas BOOLEAN,
    tema_interfaz VARCHAR(50),
    sensibilidad_mouse FLOAT,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

CREATE TABLE Buzon (
    id_mensaje INT AUTO_INCREMENT PRIMARY KEY,
    id_remitente INT NOT NULL,
    id_receptor INT NOT NULL,
    asunto_mensaje VARCHAR(100),
    contenido_mensaje VARCHAR(2000),
    fecha_envio TIMESTAMP
);

CREATE TABLE Logros (
    id_logro INT AUTO_INCREMENT PRIMARY KEY,
    nombre_logro VARCHAR(30),
    descripcion_logro VARCHAR(500),
    requisitos_obtencion VARCHAR(250),
    cantidad_jugadores_con_logro INT,
    id_primer_jugador INT
);

-- Inventario
CREATE TABLE Inventario (
    id_inventario INT AUTO_INCREMENT PRIMARY KEY,
    id_jugador INT NOT NULL,
    id_objeto INT NOT NULL,
    cantidad INT DEFAULT 1,
    FOREIGN KEY (id_jugador) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_objeto) REFERENCES Objetos(id_objeto) ON DELETE CASCADE
);

CREATE TABLE Objetos (
    id_objeto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_objeto VARCHAR(50),
    descripcion_objeto VARCHAR(500),
    id_fabricante INT,
    precio_objeto INT,
    durabilidad_objeto FLOAT
);

CREATE TABLE Armas (
    id_arma INT AUTO_INCREMENT PRIMARY KEY,
    id_objeto INT NOT NULL,
    requisitos_uso VARCHAR(100),
    peso_objeto FLOAT,
    tipo_arma VARCHAR(50),
    dano_arma FLOAT,
    FOREIGN KEY (id_objeto) REFERENCES Objetos(id_objeto)
);

CREATE TABLE Crafteos (
    id_crafteo INT AUTO_INCREMENT PRIMARY KEY,
    requisitos_creacion VARCHAR(250),
    tiempo_creacion TIME,
    id_objeto INT NOT NULL,
    materiales_creacion VARCHAR(250),
    FOREIGN KEY (id_objeto) REFERENCES Objetos(id_objeto)
);

CREATE TABLE Consumibles (
    id_consumible INT AUTO_INCREMENT PRIMARY KEY,
    nombre_consumible VARCHAR(50),
    descripcion_consumible VARCHAR(250),
    efecto_consumible VARCHAR(250),
    duracion_segundos INT
);

-- Entidades
CREATE TABLE Enemigos (
    id_enemigo INT AUTO_INCREMENT PRIMARY KEY,
    nombre_enemigo VARCHAR(50),
    descripcion_enemigo VARCHAR(500),
    debilidad_enemigo VARCHAR(100),
    vida_enemigo FLOAT,
    armadura_enemigo FLOAT
);

CREATE TABLE Jefes (
    id_jefe INT AUTO_INCREMENT PRIMARY KEY,
    nombre_jefe VARCHAR(50),
    vida_jefe FLOAT,
    descripcion_jefe VARCHAR(500),
    debilidad_jefe VARCHAR(100),
    habilidad_jefe VARCHAR(250)
);

CREATE TABLE NPCs (
    id_npc INT AUTO_INCREMENT PRIMARY KEY,
    nombre_npc VARCHAR(50),
    vida_npc FLOAT,
    ubicacion_npc VARCHAR(100),
    dialogo_inicial VARCHAR(500)
);

CREATE TABLE Mascotas (
    id_mascota INT AUTO_INCREMENT PRIMARY KEY,
    nombre_mascota VARCHAR(50),
    vida_mascota FLOAT,
    peso_mascota FLOAT,
    estamina_mascota FLOAT,
    velocidad_mascota FLOAT
);

-- Tienda
CREATE TABLE Tienda (
    id_tienda INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tienda VARCHAR(50),
    ubicacion_tienda VARCHAR(100),
    id_objeto INT NOT NULL,
    precio_objeto INT,
    FOREIGN KEY (id_objeto) REFERENCES Objetos(id_objeto)
);

CREATE TABLE Transacciones (
    id_transaccion INT AUTO_INCREMENT PRIMARY KEY,
    id_vendedor INT NOT NULL,
    id_comprador INT NOT NULL,
    id_objeto INT NOT NULL,
    fecha_transaccion TIMESTAMP,
    FOREIGN KEY (id_objeto) REFERENCES Objetos(id_objeto)
);

CREATE TABLE MicroTransacciones (
    id_micro_transaccion INT AUTO_INCREMENT PRIMARY KEY,
    precio_dolares FLOAT,
    objeto_comprado VARCHAR(250),
    fecha_compra TIMESTAMP,
    metodo_pago VARCHAR(50)
);

CREATE TABLE Pases (
    id_pase INT AUTO_INCREMENT PRIMARY KEY,
    nombre_pase VARCHAR(50),
    descripcion_pase VARCHAR(500),
    precio_pase FLOAT,
    tiempo_duracion TIME
);

CREATE TABLE OfertasEspeciales (
    id_oferta INT AUTO_INCREMENT PRIMARY KEY,
    id_objeto INT NOT NULL,
    descuento_oferta FLOAT,
    fecha_inicio DATE,
    fecha_fin DATE,
    FOREIGN KEY (id_objeto) REFERENCES Objetos(id_objeto)
);

-- Personaje
CREATE TABLE Personajes (
    id_personaje INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    nombre_personaje VARCHAR(50),
    nivel_personaje INT,
    experiencia_personaje INT,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

CREATE TABLE Personalizacion (
    id_personalizacion INT AUTO_INCREMENT PRIMARY KEY,
    id_personaje INT NOT NULL,
    color_piel VARCHAR(50),
    tipo_cabello VARCHAR(50),
    altura_personaje FLOAT,
    FOREIGN KEY (id_personaje) REFERENCES Personajes(id_personaje)
);

CREATE TABLE Razas (
    id_raza INT AUTO_INCREMENT PRIMARY KEY,
    nombre_raza VARCHAR(50),
    descripcion_raza VARCHAR(250),
    habilidades_innatas VARCHAR(250)
);

CREATE TABLE Clases (
    id_clase INT AUTO_INCREMENT PRIMARY KEY,
    nombre_clase VARCHAR(50),
    descripcion_clase VARCHAR(250),
    habilidades_clase VARCHAR(250)
);

CREATE TABLE Equipamiento (
    id_equipamiento INT AUTO_INCREMENT PRIMARY KEY,
    id_personaje INT NOT NULL,
    id_objeto INT NOT NULL,
    tipo_equipo ENUM('Casco', 'Armadura', 'Arma', 'Botas', 'Accesorio'),
    durabilidad FLOAT DEFAULT 100.0,
    FOREIGN KEY (id_personaje) REFERENCES Personajes(id_personaje) ON DELETE CASCADE,
    FOREIGN KEY (id_objeto) REFERENCES Objetos(id_objeto) ON DELETE CASCADE
);

-- Mapa
CREATE TABLE Propiedades (
    id_propiedad INT AUTO_INCREMENT PRIMARY KEY,
    nombre_propiedad VARCHAR(50),
    tipo_propiedad VARCHAR(50),
    ubicacion_propiedad VARCHAR(100),
    id_propietario INT,
    precio_propiedad FLOAT
);

CREATE TABLE Escenarios (
    id_escenario INT AUTO_INCREMENT PRIMARY KEY,
    nombre_escenario VARCHAR(50),
    tipo_escenario VARCHAR(50),
    nivel_recomendado INT,
    coordenadas_inicio VARCHAR(100),
    recursos_disponibles VARCHAR(250)
);

CREATE TABLE Spawns (
    id_spawn INT AUTO_INCREMENT PRIMARY KEY,
    id_enemigo INT NOT NULL,
    ubicacion_spawn VARCHAR(100),
    tiempo_respawn TIME,
    nivel_enemigo INT,
    FOREIGN KEY (id_enemigo) REFERENCES Enemigos(id_enemigo)
);

-- Modos Juegos
CREATE TABLE Eventos (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    nombre_evento VARCHAR(50),
    descripcion_evento VARCHAR(500),
    fecha_inicio DATE,
    fecha_fin DATE
);

CREATE TABLE TCG (
    id_carta INT AUTO_INCREMENT PRIMARY KEY,
    nombre_carta VARCHAR(50),
    tipo_carta VARCHAR(50),
    efecto_carta VARCHAR(250),
    rareza_carta VARCHAR(50)
);

CREATE TABLE Minijuegos (
    id_minijuego INT AUTO_INCREMENT PRIMARY KEY,
    nombre_minijuego VARCHAR(50),
    descripcion_minijuego VARCHAR(500),
    max_jugadores INT,
    recompensa_minijuego VARCHAR(250)
);

CREATE TABLE Misiones (
    id_mision INT AUTO_INCREMENT PRIMARY KEY,
    nombre_mision VARCHAR(50),
    descripcion_mision VARCHAR(500),
    nivel_requerido INT,
    recompensa_mision VARCHAR(250)
);

ALTER TABLE Usuarios 
MODIFY nombre_usuario VARCHAR(30) UNIQUE NOT NULL, 
MODIFY correo_usuario VARCHAR(100) UNIQUE NOT NULL,
ADD COLUMN password_hash VARCHAR(255) NOT NULL AFTER correo_usuario,
ADD COLUMN fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER password_hash,
ADD COLUMN rol ENUM('Jugador', 'Administrador') DEFAULT 'Jugador' AFTER pais_usuario;

ALTER TABLE Inventario
ADD COLUMN nombre_objeto VARCHAR(50);

ALTER TABLE Inventario
MODIFY COLUMN cantidad INT DEFAULT 1 AFTER nombre_objeto;

ALTER TABLE Equipamiento CHANGE COLUMN durabilidad durabilidad_objeto FLOAT;

ALTER TABLE Equipamiento MODIFY tipo_equipo ENUM('Casco', 'Armadura', 'Arma', 'Botas', 'Accesorio', 'Pocion');