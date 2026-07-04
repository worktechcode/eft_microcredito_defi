# Guía del Estudiante: EFT Microcréditos Colateralizados en DeFi

**Asignatura:** Fundamentos de Blockchain (BCY0010)  
**Evaluación:** Evaluación Final Transversal (EFT).  

---

## 1. Contexto Académico (EFT)

Este repositorio actúa como un **boilerplate (plantilla de código base)** pedagógico para la **Evaluación Final Transversal (EFT)** del curso **Fundamentos de Blockchain (BCY0010)**. 

El objetivo de este andamiaje (*scaffolding*) es **minimizar la fricción de sintaxis** en Solidity para que los estudiantes de pregrado se enfoquen en la arquitectura conceptual, el marco ético y regulatorio en Chile, y las interacciones del protocolo.

---

## 2. Mapa de Indicadores de Evaluación (Rúbrica)

El código y la documentación contienen marcadores específicos para preparar la defensa oral individual. Los indicadores evaluados en esta EFT son:

| Indicador (IE) | Descripción Académica | Ubicación en el Proyecto |
| :--- | :--- | :--- |
| **`[IE5 - Wallets y Llaves]`** | Uso de firmas digitales, wallets y cuentas distribuidas. | Constructor, firmas en `depositarColateralYTomarCredito`, validaciones de `borrower` en `pagarPrestamo` y definición de eventos de auditoría. |
| **`[IE6 - Ecosistema DeFi e Interfaces]`** | Interacción estándar con tokens fungibles (ERC20) mediante interfaces seguras (`IERC20`). | Uso de OpenZeppelin, `transfer` en el crédito y `transferFrom` en el retorno. |
| **`[IE9 - Rol de Oráculos]`** | Necesidad teórica de oráculos (ej. Chainlink) ante la volatilidad del colateral. | Análisis de bloque teórico al final de [MicroCreditoColateral.sol](./src/MicroCreditoColateral.sol) y en la guía. |
| **`[IE11 - Marco Normativo y Ético]`** | Ley Fintech de Chile (N° 21.521) y debates sobre liquidaciones algorítmicas autónomas. | Comentarios críticos finales en el contrato inteligente y sección regulatorio en [EFT_Guia_Estudiante.md](./docs/EFT_Guia_Estudiante.md). |

---

## 3. Estructura de Carpetas

```bash
├── README.md               # Contexto, links del proyecto y guía de inicio (Este archivo)
├── package.json            # Dependencias locales y scripts del proyecto (ESM)
├── hardhat.config.js       # Configuración del entorno de desarrollo Hardhat (ESM-first)
├── deploy.js               # Script de despliegue local automatizado (ethers.js ESM)
├── docs/
│   └── EFT_Guia_Estudiante.md # Guía docente/alumno para completar los TODOs y preparar la defensa
├── src/
│   ├── MicroCreditoColateral.sol # Contrato base con TODOs y andamiaje pedagógico
│   └── MockERC20.sol             # Token de crédito simulado para pruebas locales/Remix
└── infra/
    └── DeployRemixGuide.md       # Guía paso a paso para compilar y desplegar en Remix IDE
```

---

## 4. Instrucciones de Uso para el Laboratorio

### Opción A: Remix IDE (Recomendado para clases de laboratorio)
1. Abre [Remix IDE](https://remix.ethereum.org/).
2. Sigue las instrucciones paso a paso detalladas en la guía [DeployRemixGuide.md](./infra/DeployRemixGuide.md).
3. Rellena los **13 TODOs** de validación y transferencia en el archivo `MicroCreditoColateral.sol` para que la lógica de depósito, pago y liquidación funcione correctamente.

### Opción B: Entorno local con Hardhat (Avanzado)

#### Requerimientos del Sistema
*   **Node.js**: Versión `v18` o `v20` (recomendada).
*   **npm**: Versión `9` o superior.

#### Instrucciones de Ejecución
1. Instala las dependencias necesarias en la raíz del proyecto:
   ```bash
   npm install
   ```
2. Compila los contratos:
   ```bash
   npm run compile
   ```
3. Ejecuta las pruebas locales:
   ```bash
   npm test
   ```
4. Ejecuta el script de simulación y despliegue local:
   ```bash
   npm run deploy
   ```

---

## 5. Enlaces de Interés y Administración
*   **Jira:** (Por configurar en la intranet institucional)
*   **Loom:** (Videotutorial explicativo del laboratorio por configurar)
*   **Documentación Detallada:** [docs/EFT_Guia_Estudiante.md](./docs/EFT_Guia_Estudiante.md)
*   **Estado:** Iniciado y listo para distribución a estudiantes.
