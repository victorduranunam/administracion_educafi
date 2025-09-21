import pandas as pd
import tkinter as tk
from tkinter import filedialog

def seleccionar_archivo():
    root = tk.Tk()
    root.withdraw()
    archivo = filedialog.askopenfilename(filetypes=[("Excel files", "*.xlsx;*.xls")])
    return archivo

def cargar_datos(archivo):
    try:
        df = pd.read_excel(archivo, dtype=str)
        df = df.fillna("")  # Reemplaza valores NaN con cadena vacía
        df["Clave Unica"] = df["Nombre"].str.strip() + " " + df["Apellido(s)"].str.strip() + " " + df["Dirección Email"].str.strip()
        return set(df["Clave Unica"])
    except Exception as e:
        print(f"Error al leer el archivo {archivo}: {e}")
        return set()

def main():
    print("Seleccione el primer archivo (BASE)")
    archivo1 = seleccionar_archivo()
    print("Seleccione el segundo archivo (NUEVA LISTA)")
    archivo2 = seleccionar_archivo()
    
    base_alumnos = cargar_datos(archivo1)
    nueva_lista = cargar_datos(archivo2)
    
    alumnos_agregados = nueva_lista - base_alumnos
    alumnos_eliminados = base_alumnos - nueva_lista
    
    print("\nAlumnos Agregados:")
    for alumno in alumnos_agregados:
        print(alumno)
    
    print("\nAlumnos Eliminados:")
    for alumno in alumnos_eliminados:
        print(alumno)

if __name__ == "__main__":
    main()
