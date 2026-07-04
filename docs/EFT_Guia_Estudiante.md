# Guía del Estudiante: EFT Microcréditos Colateralizados en DeFi

**Asignatura:** Fundamentos de Blockchain (BCY0010)  
**Evaluación:** Evaluación Final Transversal (EFT).  

Esta guía proporciona el andamiaje pedagógico y técnico necesario para preparar la **Evaluación Final Transversal (EFT)**. 
El objetivo es que logres completar el código del Smart Contract, comprender las implicancias normativas en Chile y defender con éxito tu proyecto de manera individual.

---

## 1. Introducción al Caso de Uso

El caso de estudio consiste en **Microcréditos Colateralizados en Finanzas Descentralizadas (DeFi)**. Este modelo permite resolver el problema de la confianza de forma puramente tecnológica y automatizada, reemplazando a los intermediarios bancarios tradicionales por código auto-ejecutable.

### Dinámica Financiera del Contrato
1. **Solicitud y Garantía:** El prestatario (Borrower) deposita **Ether (ETH)** en el contrato inteligente como garantía de pago (colateral). A cambio, el contrato le transfiere de forma automatizada un monto menor de un token fungible (representando el **crédito**).
2. **Amortización:** El prestatario debe devolver el monto exacto de tokens de crédito al contrato antes de la fecha límite establecida (`timestampLimite`). Al realizar el pago, el contrato le devuelve íntegramente su colateral en Ether.
3. **Incumplimiento (Liquidación):** Si el plazo expira y el prestatario no ha devuelto los tokens, el administrador (Lender/Owner) puede activar la función de **liquidación**, transfiriendo el Ether del colateral a su propia wallet y cerrando el préstamo.

---

## 2. Resolviendo los "Completa Aquí" (TODOs)

El archivo [MicroCreditoColateral.sol](./src/MicroCreditoColateral.sol) contiene 13 secciones `TODO` que debes programar para completar la lógica operativa del contrato. A continuación se explica cada uno:

### Función: `depositarColateralYTomarCredito`

* **TODO 1: Validar que el préstamo esté en estado INACTIVO**
  * *Explicación:* No se puede pedir un nuevo crédito si ya hay uno activo o en proceso de liquidación.
  * *Solución:*
    ```solidity
    require(estadoPrestamo == EstadoPrestamo.INACTIVO, "El prestamo ya esta activo o en otro estado");
    ```

* **TODO 2: Validar que el colateral (msg.value) sea mayor a cero**
  * *Explicación:* El prestatario debe depositar Ether real como garantía para sustentar el préstamo.
  * *Solución:*
    ```solidity
    require(msg.value > 0, "El colateral depositado debe ser mayor a cero");
    ```

* **TODO 3: Validar el monto de crédito solicitado**
  * *Explicación:* La solicitud debe ser superior a cero y el contrato debe poseer suficientes tokens en su balance para prestar esa cantidad.
  * *Solución:*
    ```solidity
    require(_montoCredito > 0, "El monto de credito debe ser mayor a cero");
    require(tokenCredito.balanceOf(address(this)) >= _montoCredito, "El contrato no cuenta con suficiente liquidez de credito");
    ```

* **TODO 4: Validar que la duración sea mayor a cero**
  * *Solución:*
    ```solidity
    require(_duracionSegundos > 0, "La duracion del prestamo debe ser mayor a cero");
    ```

* **TODO 5: Transferir tokens de crédito al prestatario**
  * *Explicación:* Usamos la interfaz de ERC20 para mover los tokens del contrato a la wallet del prestatario.
  * *Solución:*
    ```solidity
    require(tokenCredito.transfer(borrower, _montoCredito), "Fallo la transferencia del credito");
    ```

---

### Función: `pagarPrestamo`

* **TODO 6: Validar que el préstamo esté ACTIVO**
  * *Solución:*
    ```solidity
    require(estadoPrestamo == EstadoPrestamo.ACTIVO, "El prestamo no esta activo");
    ```

* **TODO 7: Validar que el pagador sea el prestatario original**
  * *Explicación:* Solo quien tomó la deuda puede liberarla y retirar el colateral original.
  * *Solución:*
    ```solidity
    require(msg.sender == borrower, "Solo el prestatario original puede pagar la deuda");
    ```

* **TODO 8: Validar que el plazo no haya expirado**
  * *Explicación:* El tiempo del bloque actual (`block.timestamp`) no debe haber pasado de la fecha límite establecida (`timestampLimite`).
  * *Solución:*
    ```solidity
    require(block.timestamp <= timestampLimite, "El plazo para pagar la deuda ha expirado");
    ```

* **TODO 9: Transferir tokens de crédito desde el prestatario al contrato**
  * *Explicación:* El contrato retira los tokens de la wallet del usuario. El usuario debe haber ejecutado primero la transacción `approve` en el contrato ERC20 para autorizar esta extracción.
  * *Solución:*
    ```solidity
    require(tokenCredito.transferFrom(msg.sender, address(this), montoCredito), "Fallo la devolucion de tokens de credito");
    ```

* **TODO 10: Devolver el Ether de garantía al prestatario**
  * *Explicación:* Realizamos una transferencia segura de Ether utilizando llamadas de bajo nivel `.call` sobre la dirección del prestatario convertida a `payable`, verificando el valor booleano de éxito retornado con un `require` para evitar fallos por límite de gas (2300) asociados a `.transfer()`.
  * *Solución:*
    ```solidity
    (bool success, ) = payable(borrower).call{value: montoColateral}("");
    require(success, "Fallo el reintegro de Ether del colateral");
    ```

---

### Función: `liquidarGarantia`

* **TODO 11: Validar que el préstamo esté ACTIVO**
  * *Solución:*
    ```solidity
    require(estadoPrestamo == EstadoPrestamo.ACTIVO, "No hay prestamo activo para liquidar");
    ```

* **TODO 12: Validar que el plazo haya expirado**
  * *Explicación:* Solo se puede liquidar el colateral si el plazo ha concluido y el préstamo no fue pagado.
  * *Solución:*
    ```solidity
    require(block.timestamp > timestampLimite, "El plazo de pago aun no ha expirado");
    ```

* **TODO 13: Transferir el Ether de garantía al administrador**
  * *Explicación:* Transferimos de manera segura los fondos acumulados en Ether al administrador utilizando la llamada de bajo nivel `.call{value: ...}("")` con validación de retorno mediante `require`.
  * *Solución:*
    ```solidity
    (bool success, ) = payable(owner).call{value: colateralALiquidar}("");
    require(success, "Fallo la transferencia del colateral liquidado");
    ```

---

## 3. Análisis de Indicadores de Evaluación (IE) para la Defensa Individual

En tu defensa oral individual (80% de la nota), la comisión te hará preguntas basadas en los siguientes lineamientos específicos del programa de estudios:

### [IE5 - Wallets y Llaves]
* **Definición conceptual:** En blockchain no existen nombres de usuario ni contraseñas. La identidad se basa en pares de llaves criptográficas (públicas y privadas). Una wallet resguarda la llave privada con la que se firman digitalmente las transacciones.
* **Aplicación en el código:** Cuando invocamos funciones como `depositarColateralYTomarCredito()`, la variable global `msg.sender` captura la dirección pública derivada de la llave que firmó la transacción. Esto nos permite mapear al prestatario sin necesidad de registros de identidad tradicionales.
* **Eventos para auditoría:** Los eventos como `ColateralDepositado` emiten datos indexados (`indexed`), lo que permite a sistemas externos (indexadores, front-ends, auditores) filtrar de manera eficiente las firmas y acciones de wallets específicas.

### [IE6 - Ecosistema DeFi e Interfaces]
* **Definición conceptual:** El ecosistema DeFi se construye sobre la "legibilidad" e interactividad de estándares de tokens. La interfaz `IERC20` define las funciones estándar que cualquier token fungible de Ethereum debe implementar (como `transfer`, `transferFrom`, y `balanceOf`).
* **Flujo de aprobación (Approve & TransferFrom):** Para pagar el préstamo, el usuario debe seguir un flujo de dos pasos fundamental en DeFi:
  1. Llamar a la función `approve(address_del_contrato_microcredito, monto)` en el contrato del token de crédito. Esto otorga permiso para retirar fondos.
  2. Llamar a la función `pagarPrestamo()` en nuestro contrato, la cual internamente ejecuta `transferFrom` para retirar de forma segura los tokens autorizados.

### [IE9 - Rol de Oráculos]
* **Definición conceptual:** Las blockchains son redes deterministas aisladas que no pueden realizar solicitudes HTTP o consultar datos fuera de la red sin romper el consenso. Un **Oráculo** (ej. Chainlink) es una red descentralizada que inyecta datos del mundo real (como precios de divisas) de forma confiable dentro de la cadena.
* **Riesgo del Contrato Actual:** Si el precio de Ether cae fuertemente, el colateral valdrá menos que el crédito recibido. El prestatario preferirá quedarse con el crédito, generando deuda incobrable para el protocolo.
* **Mitigación:** Conectaríamos un feed de Chainlink (`AggregatorV3Interface`) para calcular en tiempo real el valor en dólares del Ether depositado (`msg.value`) y del token prestado. Esto nos permitiría imponer un umbral de sobrecolateralización (LTV) e iniciar liquidaciones automáticas si el colateral se devalúa.

### [IE11 - Marco Normativo y Ético]
* **Ley Fintech Chilena (N° 21.521):**
  * *Custodia:* El smart contract actúa como un software autónomo de custodia de Ether. Ante la regulación chilena y la CMF, las entidades que facilitan plataformas de criptoactivos deben implementar rigurosas medidas de prevención del lavado de dinero (KYC/UAF), auditoría tecnológica y segregación de activos, lo que genera tensión con el anonimato puro.
  * *Naturaleza del Crédito:* Prestar capital de forma automatizada al público general puede ser considerado captación o intermediación financiera, lo que exige licencias de operación específicas de la CMF.
* **Dilemas Éticos:**
  * *La Inmutabilidad:* Si la red Ethereum sufre congestión y las tarifas de gas suben a niveles impagables, un usuario de bajos recursos no podrá enviar su transacción para pagar su deuda a tiempo. El contrato, siendo ciego a factores humanos, liquidará su garantía automáticamente, despojándolo de su capital.
  * *Exclusión Financiera:* La sobrecolateralización (ej. pedir 150% de garantía para prestar 100%) contradice el principio de inclusión financiera, ya que las personas con menos recursos no tienen capital inicial para colateralizar, beneficiando principalmente a especuladores y tenedores de riqueza previa.
