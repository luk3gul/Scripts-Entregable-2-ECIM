# Entregable 2 - ECIM (Resolución Computacional)

**Autores:** Lucas Gulías Fernández, Bernat Cañaveras Laguarda, Alex Clúa Illán
**Asignatura:** Estructuras y Construcciones Industriales (UPC)

Este repositorio contiene los scripts desarrollados en MATLAB para la resolución de los problemas del Entregable 2.

### Archivos incluidos:

* `P1_Entreganle2_ECIM.m`: Resolución del cálculo plástico de la viga mediante el método de los mecanismos (Neal-Symonds). El script calcula el momento plástico ($M_p$) necesario para cada mecanismo, identifica automáticamente el mecanismo crítico y determina el momento plástico de diseño aplicando el coeficiente de seguridad.
* `P2_Entreganle2_ECIM.m`: Análisis de flexión de la placa rectangular empleando el método de Navier. Incluye el estudio de convergencia de la flecha en el centro según el número de términos de la serie, el cálculo de las tensiones y momentos máximos, y la generación visual de mapas de contorno (2D) y superficies (3D) de la flecha de la placa.

### Ejecución

Para visualizar los resultados, simplemente descargue los archivos `.m` y ejecútelos en el entorno de MATLAB (versión recomendada R2023b o superior). Los resultados se imprimirán directamente en la *Command Window* y se generarán las figuras correspondientes.
