# makefile
<!-- TODO: Explicar el archivo make, y el directorio build -->
## Estructura del proyecto
```txt
|-- build/
|   |-- depends/
|   |-- objs/
|   |-- results/
|-- docs/
|-- src/
|-- test/
|-- unity/
|   |-- src/
|       |-- unity.c
|       |-- unity.h
|       |-- unity_internals.h
|-- makefile
```

Este `makefile`:
1. Configura variables según el sistema operativo.
2. Encuentra y compila archivos de prueba.
3. Genera ejecutables y los ejecuta.
4. Muestra los resultados de las pruebas.
5. Limpia archivos cuando se ejecuta `make clean`.
