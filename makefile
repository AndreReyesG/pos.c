# Dectectar el SO que estamos ocupando, y adjuntar los comandos que necesitamos
ifeq ($(OS),Windows_NT)
  ifeq ($(shell uname -s),) # si estamos cmd.exe o powershell
	CLEANUP = del /F /Q
	MKDIR = mkdir
  else # si estamos en un entorno tipo bash
	CLEANUP = rm -f
	MKDIR = mkdir -p
  endif
	TARGET_EXTENSION=.exe
else
	CLEANUP = rm -f
	MKDIR = mkdir -p
	TARGET_EXTENSION=.out
endif

# `.PHONY` evita confilictos con archivos del mismo nombre
.PHONY: clean
.PHONY: test

PATHU = unity/src/
PATHS = src/
PATHT = test/
PATHB = build/
PATHD = build/depends/
PATHO = build/objs/
PATHR = build/results/

BUILD_PATHS = $(PATHB) $(PATHD) $(PATHO) $(PATHR)

# Usa `.wildcard` para buscar todos los archivos `.c` en la carpeta `test/`
SRCT = $(wildcard $(PATHT)*.c)

COMPILE=gcc -c
LINK=gcc
DEPEND=gcc -MM -MG -MF
CFLAGS=-I. -I $(PATHU) -I $(PATHS) -DTEST

# Convertir los archivos `test/xxx_test.c` en `build/results/xxx_test.txt`
RESULTS = $(patsubst $(PATHT)%_test.c,$(PATHR)%_test.txt,$(SRCT) )

# Ocupar `grep` para filtrar los resultados de los pruebas
PASSED = `grep -s PASS $(PATHR)*.txt`
FAIL = `grep -s FAIL $(PATHR)*.txt`
IGNORE = `grep -s IGNORE $(PATHR)*.txt`

# Ejecutar pruebas
test: $(BUILD_PATHS) $(RESULTS)
	@echo "-----------------------\nIGNORES:\n-----------------------"
	@echo "$(IGNORE)"
	@echo "-----------------------\nFAILURES:\n-----------------------"
	@echo "$(FAIL)"
	@echo "-----------------------\nPASSED:\n-----------------------"
	@echo "$(PASSED)"
	@echo "\nDONE"

# Generación de resultados
# - Ejecuta los binarios de prueba y guarda la salida en `build/results/xxx_test.c`
$(PATHR)%.txt: $(PATHB)%.$(TARGET_EXTENSION)
	-./$< > $@ 2>&1

# Creación de ejecutables
# - Compila y enlaza los archivos `.o` en un ejecutable.
$(PATHB)%_test.$(TARGET_EXTENSION): $(PATHO)%_test.o $(PATHO)%.o $(PATHO)unity.o #$(PATHD)%_test.d
	$(LINK) -o $@ $^

# Reglas de compilación
# - Convierte archivos `.c` en `.o`
$(PATHO)%.o:: $(PATHT)%.c
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATHO)%.o:: $(PATHS)%.c
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATHO)%.o:: $(PATHU)%.c $(PATHU)%.h
	$(COMPILE) $(CFLAGS) $< -o $@

# Generación de dependencias
# - Genera archivos de dependencias (`.d`) para cada archivo de prueba.
$(PATHD)%.d:: $(PATHT)%.c
	$(DEPEND) $@ $<

# Crear carpetas
$(PATHB):
	$(MKDIR) $(PATHB)

$(PATHD):
	$(MKDIR) $(PATHD)

$(PATHO):
	$(MKDIR) $(PATHO)

$(PATHR):
	$(MKDIR) $(PATHR)

# Limpiar
# - Borra los archivos `.o`, ejecutables y resultados de pruebas
clean:
	$(CLEANUP) $(PATHO)*.o
	$(CLEANUP) $(PATHB)*$(TARGET_EXTENSION)
	$(CLEANUP) $(PATHR)*.txt

# Archivos que NO se borrarán
# - Estos archivos no se borrarán automaticamente
.PRECIOUS: $(PATHB)%_test$(TARGET_EXTENSION)
.PRECIOUS: $(PATHD)%.d
.PRECIOUS: $(PATHO)%.o
.PRECIOUS: $(PATHR)%.txt
