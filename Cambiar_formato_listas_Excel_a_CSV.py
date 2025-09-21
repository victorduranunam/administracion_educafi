import pandas as pd
from tkinter import Tk
from tkinter.filedialog import askopenfilename

def extraer_datos_excel():
    # Ocultar la ventana principal de Tkinter
    Tk().withdraw()

    # Abrir explorador de archivos para seleccionar el archivo Excel
    archivo = askopenfilename(
        title="Selecciona el archivo Excel (formato .xlsx)", 
        filetypes=[("Archivos Excel", "*.xlsx")]
    )
    if not archivo:
        print("No seleccionaste un archivo.")
        return

    # Solicitar información adicional
    fila_inicial = int(input("Ingrese la fila inicial (número entero): "))
    fila_final = int(input("Ingrese la fila final (número entero): "))
    course1 = input("Ingrese la clave del curso: ")

    # Obtener el nombre del archivo sin extensión y agregar ".csv"
    nombre_salida = archivo.rsplit('.', 1)[0] + ".csv"

    # Leer el archivo Excel
    df = pd.read_excel(archivo, header=None)

    # Asegurar que se incluyen ambas filas, inicial y final, para la extracción
    cuentas = df.iloc[fila_inicial - 1:fila_final, 2]
    nombres_completos = df.iloc[fila_inicial - 1:fila_final, 3]
    correos = df.iloc[fila_inicial - 1:fila_final, 10]

    # Crear listas para almacenar los datos procesados
    usernames = []
    passwords = []
    lastnames = []
    firstnames = []
    emails = []
    courses = []

    # Procesar cada fila
    for cuenta, nombre_completo, correo in zip(cuentas, nombres_completos, correos):
        nombres_separados = nombre_completo.split()
        apellidos = ' '.join(nombres_separados[:2])
        nombres = ' '.join(nombres_separados[2:])

        # Almacenar los datos en las listas
        usernames.append(cuenta)
        passwords.append(cuenta)
        lastnames.append(apellidos)
        firstnames.append(nombres)
        emails.append(correo)
        courses.append(course1)

    # Crear un DataFrame con los datos procesados
    df_output = pd.DataFrame({
        'username': usernames,
        'password': passwords,
        'lastname': lastnames,
        'firstname': firstnames,
        'email': emails,
        'course1': courses
    })

    # Guardar el DataFrame en un archivo CSV con codificación utf-8-sig
    df_output.to_csv(nombre_salida, index=False, quotechar='"', encoding='utf-8-sig')

    print(f"Datos extraídos y guardados en {nombre_salida}.")

# Ejecutar la función principal
extraer_datos_excel()
