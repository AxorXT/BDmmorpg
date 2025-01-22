import mysql.connector
import bcrypt
from datetime import datetime

DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "Techangel#123",
    "database": "bdmmo"
}

def conectar_db():
    return mysql.connector.connect(**DB_CONFIG)


# Encriptar contraseña
def encriptar_password(password):
    return bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()


# Verificar contraseña
def verificar_password(password, password_hash):
    return bcrypt.checkpw(password.encode(), password_hash.encode())


# Validación de datos
def validar_datos(nombre, correo, password, telefono, fecha_nacimiento, pais):
    if len(nombre) < 3 or len(nombre) > 30:
        print("El nombre debe tener entre 3 y 30 caracteres.")
        return False
    if "@" not in correo or len(correo) > 100:
        print("Correo inválido.")
        return False
    if len(password) < 8:
        print("La contraseña debe tener al menos 8 caracteres.")
        return False
    return True


# Registro de usuario
def registrar_usuario(nombre, correo, password, telefono, fecha_nacimiento, pais, rol="Jugador"):
    if not validar_datos(nombre, correo, password, telefono, fecha_nacimiento, pais):
        return

    password_hash = encriptar_password(password)
    conexion = conectar_db()
    cursor = conexion.cursor()
    consulta = """
        INSERT INTO Usuarios (nombre_usuario, correo_usuario, password_hash, telefono_usuario, fecha_nacimiento, pais_usuario, rol)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
    """
    try:
        cursor.execute(consulta, (nombre, correo, password_hash, telefono, fecha_nacimiento, pais, rol))
        conexion.commit()
        print("Usuario registrado exitosamente.")
    except mysql.connector.Error as err:
        print("Error al registrar usuario:", err)
    finally:
        cursor.close()
        conexion.close()


# Inicio de sesión seguro
def iniciar_sesion(nombre_usuario, password):
    conexion = conectar_db()
    cursor = conexion.cursor()
    consulta = "SELECT id_usuario, password_hash FROM Usuarios WHERE nombre_usuario = %s"
    cursor.execute(consulta, (nombre_usuario,))
    usuario = cursor.fetchone()
    cursor.close()
    conexion.close()

    if usuario and verificar_password(password, usuario[1]):
        print("Inicio de sesión exitoso.")
        return usuario[0]
    else:
        print("Credenciales incorrectas.")
        return None


# Recuperación de contraseña (simulada con nueva contraseña)
def recuperar_contraseña(nombre_usuario, nueva_password):
    nueva_password_hash = encriptar_password(nueva_password)
    conexion = conectar_db()
    cursor = conexion.cursor()
    consulta = "UPDATE Usuarios SET password_hash = %s WHERE nombre_usuario = %s"
    try:
        cursor.execute(consulta, (nueva_password_hash, nombre_usuario))
        conexion.commit()
        print("Contraseña actualizada correctamente.")
    except mysql.connector.Error as err:
        print("Error al actualizar contraseña:", err)
    finally:
        cursor.close()
        conexion.close()


# Gestión de roles y permisos
def cambiar_rol(id_usuario, nuevo_rol):
    conexion = conectar_db()
    cursor = conexion.cursor()
    consulta = "UPDATE Usuarios SET rol = %s WHERE id_usuario = %s"
    try:
        cursor.execute(consulta, (nuevo_rol, id_usuario))
        conexion.commit()
        print("Rol actualizado exitosamente.")
    except mysql.connector.Error as err:
        print("Error al actualizar rol:", err)
    finally:
        cursor.close()
        conexion.close()


# Gestión de Personajes
def crear_personaje(id_usuario, nombre_personaje):
    conexion = conectar_db()
    cursor = conexion.cursor()
    consulta = """
        INSERT INTO Personajes (id_usuario, nombre_personaje, nivel_personaje, experiencia_personaje)
        VALUES (%s, %s, %s, %s)
    """
    try:
        cursor.execute(consulta, (id_usuario, nombre_personaje, 1, 0))
        conexion.commit()
        print("Personaje creado exitosamente.")
    except mysql.connector.Error as err:
        print("Error al crear personaje:", err)
    finally:
        cursor.close()
        conexion.close()


def progresar_experiencia(id_personaje, experiencia):
    conexion = conectar_db()
    cursor = conexion.cursor()
    consulta = """
        UPDATE Personajes SET experiencia_personaje = experiencia_personaje + %s
        WHERE id_personaje = %s
    """
    try:
        cursor.execute(consulta, (experiencia, id_personaje))
        conexion.commit()
        print("Experiencia añadida exitosamente.")
    except mysql.connector.Error as err:
        print("Error al añadir experiencia:", err)
    finally:
        cursor.close()
        conexion.close()

# Gestión de Inventario
def agregar_item_al_inventario(id_jugador, nombre_objeto, cantidad):
    conexion = conectar_db()
    cursor = conexion.cursor()

    # Obtener el id_objeto y el nombre_objeto del objeto creado (se espera que el objeto ya exista en la tabla 'Objetos')
    consulta_item = "SELECT id_objeto, nombre_objeto FROM Objetos WHERE nombre_objeto = %s"
    cursor.execute(consulta_item, (nombre_objeto,))
    item = cursor.fetchone()

    if not item:
        print(f"El objeto '{nombre_objeto}' no existe en la base de datos.")
        cursor.close()
        conexion.close()
        return

    id_objeto = item[0]
    nombre_objeto_db = item[1]  # Esto es el nombre del objeto recuperado de la base de datos

    # Consulta para insertar el objeto en el inventario del personaje (se usa ON DUPLICATE KEY para no duplicar)
    consulta_inventario = """
        INSERT INTO Inventario (id_jugador, id_objeto, nombre_objeto, cantidad)
        VALUES (%s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE cantidad = cantidad + VALUES(cantidad)
    """
    try:
        cursor.execute(consulta_inventario, (id_jugador, id_objeto, nombre_objeto_db, cantidad))
        conexion.commit()
        print(f"Objeto '{nombre_objeto}' agregado al inventario del jugador {id_jugador}.")
    except mysql.connector.Error as err:
        print("Error al agregar objeto al inventario:", err)
    finally:
        cursor.close()
        conexion.close()


def crear_objeto(nombre_objeto, descripcion_objeto, id_fabricante, precio_objeto, durabilidad_objeto):
    conexion = conectar_db()
    cursor = conexion.cursor()
    consulta = """
        INSERT INTO Objetos (nombre_objeto, descripcion_objeto, id_fabricante, precio_objeto, durabilidad_objeto)
        VALUES (%s, %s, %s, %s, %s)
    """
    try:
        cursor.execute(consulta, (nombre_objeto, descripcion_objeto, id_fabricante, precio_objeto, durabilidad_objeto))
        conexion.commit()
        print(f"Objeto '{nombre_objeto}' creado exitosamente.")
    except mysql.connector.Error as err:
        print("Error al crear objeto:", err)
    finally:
        cursor.close()
        conexion.close()


def equipar_item(id_personaje, nombre_objeto, tipo_equipo):
    # Validar que el tipo_equipo sea uno de los valores válidos
    tipos_validos = ['Casco', 'Armadura', 'Arma', 'Botas', 'Accesorio', 'Pocion']
    if tipo_equipo not in tipos_validos:
        print(f"Error: '{tipo_equipo}' no es un tipo de equipo válido.")
        return

    conexion = conectar_db()
    cursor = conexion.cursor()

    # Consulta para obtener el id_objeto y la durabilidad_objeto del objeto
    consulta_item = "SELECT id_objeto, durabilidad_objeto FROM Objetos WHERE nombre_objeto = %s"
    cursor.execute(consulta_item, (nombre_objeto,))
    item = cursor.fetchone()

    if not item:
        print(f"El objeto '{nombre_objeto}' no existe.")
        cursor.close()
        conexion.close()
        return

    id_objeto = item[0]
    durabilidad_objeto = item[1]  # Obtener la durabilidad del objeto

    # Consulta para insertar el objeto en el equipamiento
    consulta_equipar = """
        INSERT INTO Equipamiento (id_personaje, id_objeto, tipo_equipo, durabilidad_objeto)
        VALUES (%s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE tipo_equipo = VALUES(tipo_equipo), durabilidad_objeto = VALUES(durabilidad_objeto)
    """
    try:
        cursor.execute(consulta_equipar, (id_personaje, id_objeto, tipo_equipo, durabilidad_objeto))
        conexion.commit()
        print(f"Objeto '{nombre_objeto}' equipado como '{tipo_equipo}' para el personaje {id_personaje}.")
    except mysql.connector.Error as err:
        print(f"Error al equipar objeto: {err}")
    finally:
        cursor.close()
        conexion.close()


# Menú principal
def menu_gestion_usuarios():
    while True:
        print("\n--- Gestión de Usuarios ---")
        print("1. Registrar usuario")
        print("2. Iniciar sesión")
        print("3. Recuperar contraseña")
        print("4. Cambiar rol de usuario")
        print("0. Volver")
        opcion = input("Selecciona una opción: ")

        if opcion == "1":
            nombre = input("Nombre de usuario: ")
            correo = input("Correo electrónico: ")
            password = input("Contraseña: ")
            telefono = input("Teléfono: ")
            fecha_nacimiento = input("Fecha de nacimiento (YYYY-MM-DD): ")
            pais = input("País: ")
            registrar_usuario(nombre, correo, password, telefono, fecha_nacimiento, pais)
        elif opcion == "2":
            nombre = input("Nombre de usuario: ")
            password = input("Contraseña: ")
            iniciar_sesion(nombre, password)
        elif opcion == "3":
            nombre = input("Nombre de usuario: ")
            nueva_password = input("Nueva contraseña: ")
            recuperar_contraseña(nombre, nueva_password)
        elif opcion == "4":
            id_usuario = int(input("ID del usuario: "))
            nuevo_rol = input("Nuevo rol (Jugador / Administrador): ")
            cambiar_rol(id_usuario, nuevo_rol)
        elif opcion == "0":
            break
        else:
            print("Opción inválida.")


def menu_gestion_personajes():
    while True:
        print("\n--- Gestión de Personajes ---")
        print("1. Crear personaje")
        print("2. Progresar experiencia")
        print("3. Agregar objeto al inventario")
        print("4. Crear nuevo objeto")
        print("5. Equipar objeto")
        print("0. Volver")
        opcion = input("Selecciona una opción: ")

        if opcion == "1":
            id_usuario = int(input("ID del usuario: "))
            nombre_personaje = input("Nombre del personaje: ")
            crear_personaje(id_usuario, nombre_personaje)
        elif opcion == "2":
            id_personaje = int(input("ID del personaje: "))
            experiencia = int(input("Cantidad de experiencia: "))
            progresar_experiencia(id_personaje, experiencia)
        elif opcion == "3":
            id_personaje = int(input("ID del personaje: "))
            nombre_objeto = input("Nombre del objeto: ")
            cantidad = int(input("Cantidad: "))
            agregar_item_al_inventario(id_personaje, nombre_objeto, cantidad)
        elif opcion == "4":
            nombre_objeto = input("Nombre del objeto: ")
            descripcion_objeto = input("Descripción del objeto: ")
            id_fabricante = int(input("ID del fabricante: "))
            precio_objeto = int(input("Precio del objeto: "))
            durabilidad_objeto = float(input("Durabilidad del objeto: "))
            crear_objeto(nombre_objeto, descripcion_objeto, id_fabricante, precio_objeto, durabilidad_objeto)
        elif opcion == "5":
            id_personaje = int(input("ID del personaje: "))
            nombre_objeto = input("Nombre del objeto: ")
            tipo_equipo = input("Tipo de equipo (Casco, Armadura, Arma, Botas, Accesorio, Pocion): ")
            equipar_item(id_personaje, nombre_objeto, tipo_equipo)
        elif opcion == "0":
            break
        else:
            print("Opción inválida.")


if __name__ == "__main__":
    while True:
        print("\n--- Menú Principal ---")
        print("1. Gestión de Usuarios")
        print("2. Gestión de Personajes")
        print("0. Salir")
        opcion = input("Selecciona una opción: ")

        if opcion == "1":
            menu_gestion_usuarios()
        elif opcion == "2":
            menu_gestion_personajes()
        elif opcion == "0":
            print("Saliendo...")
            break
        else:
            print("Opción inválida.")