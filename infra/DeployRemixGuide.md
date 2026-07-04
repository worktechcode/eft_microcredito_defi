# Guía de Despliegue y Pruebas en Remix IDE

Esta guía detalla el flujo paso a paso para compilar y probar los contratos inteligentes en **Remix IDE** (https://remix.ethereum.org/) utilizando la máquina virtual del navegador (Remix VM).

---

## Paso 1: Cargar los Contratos en Remix
1. Abre [Remix IDE](https://remix.ethereum.org/).
2. En la barra lateral izquierda, dentro de la sección **File Explorer**, crea dos archivos dentro de la carpeta `contracts`:
   * `MockERC20.sol`: Copia el contenido de [MockERC20.sol](./src/MockERC20.sol).
   * `MicroCreditoColateral.sol`: Copia el contenido de [MicroCreditoColateral.sol](./src/MicroCreditoColateral.sol).

---

## Paso 2: Compilación de Contratos
1. Ve a la pestaña **Solidity Compiler** (icono de compilador de Solidity en la barra lateral izquierda).
2. Selecciona la versión del compilador: `0.8.20` o superior (preferiblemente `0.8.24`).
3. Haz clic en **Compile MockERC20.sol**.
4. Haz clic en **Compile MicroCreditoColateral.sol**.
   * *Nota:* Remix resolverá de forma automática las importaciones de OpenZeppelin desde npm.

---

## Paso 3: Despliegue (Simulación)
1. Ve a la pestaña **Deploy & Run Transactions** (icono de Ethereum con el play en la barra lateral).
2. Asegúrate de tener seleccionado **Remix VM (Cancun)** o **Remix VM (Shanghai)** en la casilla *ENVIRONMENT*. Esto proporciona 10 cuentas de prueba con 100 Ether virtuales cada una.
3. Despleguemos primero el Token:
   * En el menú desplegable *CONTRACT*, selecciona `MockERC20`.
   * Haz clic en **Deploy**.
   * Copia la dirección del contrato `MockERC20` desplegado desde la sección *Deployed Contracts* (abajo a la izquierda).
4. Despleguemos el contrato de Préstamo:
   * En el menú desplegable *CONTRACT*, selecciona `MicroCreditoColateral`.
   * En la casilla al lado del botón *Deploy*, pega la dirección del contrato `MockERC20` que copiaste en el paso anterior.
   * Haz clic en **Deploy**.

---

## Paso 4: Configurar los Fondos para la Simulación
Para que el contrato pueda prestar tokens, debe tener liquidez.
1. En *Deployed Contracts*, despliega el menú del contrato `MockERC20`.
2. Llama a la función `transfer` para enviar fondos al contrato de préstamos:
   * **recipient:** Dirección del contrato `MicroCreditoColateral` desplegado.
   * **amount:** Un número grande, por ejemplo `500000000000000000000` (500 tokens en 18 decimales).
   * Haz clic en **transact**.
3. Verifica el balance del contrato llamando a la función `balanceOf` en el contrato del token, ingresando la dirección de `MicroCreditoColateral`.

---

## Paso 5: Probar el Flujo del Préstamo (Estudiante)
Usa diferentes cuentas virtuales de Remix para simular los roles (Administrador y Prestatario).

### Acción 1: Tomar el Préstamo
1. Cambia a la **Cuenta 2** (el Prestatario) en el menú *ACCOUNT*.
2. Ve al panel del contrato `MicroCreditoColateral`.
3. Configura el envío de Ether en las casillas superiores:
   * **VALUE:** `5`
   * **UNIT:** `Ether`
4. Expande el botón `depositarColateralYTomarCredito`:
   * **_montoCredito:** `100000000000000000000` (100 tokens solicitados).
   * **_duracionSegundos:** `60` (1 minuto de plazo).
5. Haz clic en **transact**.
6. Verifica que el estado del préstamo en el contrato ahora sea `1` (`EstadoPrestamo.ACTIVO`) y que tu cuenta 2 posea los 100 tokens en su balance.

### Acción 2: Devolver el Préstamo (Dentro del Plazo)
1. Antes de que pasen los 60 segundos, ve al panel del contrato del **MockERC20**.
2. Debes aprobar al contrato de préstamos para retirar tus tokens:
   * Llama a `approve`:
     * **spender:** Dirección de `MicroCreditoColateral`.
     * **amount:** `100000000000000000000` (los 100 tokens a devolver).
   * Haz clic en **transact**.
3. Vuelve al panel del contrato `MicroCreditoColateral`.
4. Asegúrate de estar en la **Cuenta 2** y haz clic en la función `pagarPrestamo`.
5. Verifica que tu balance en Ether haya retornado a los ~100 ETH originales, que tus tokens se hayan devuelto y que el estado sea `2` (`EstadoPrestamo.PAGADO`).

### Acción 3: Probar la Liquidación (Fuera del Plazo)
1. Vuelve a tomar un préstamo con la Cuenta 2 (repetir Acción 1), pero esta vez establece `_duracionSegundos` en `5` (5 segundos).
2. Espera 6 segundos.
3. Cambia a la **Cuenta 1** (el Administrador/Owner).
4. Haz clic en `liquidarGarantia`.
5. Verifica que el Ether de garantía se transfirió a la Cuenta 1 del Administrador y que el préstamo ahora está en estado `3` (`EstadoPrestamo.LIQUIDADO`).
