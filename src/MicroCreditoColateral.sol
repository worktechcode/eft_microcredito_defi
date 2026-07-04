// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// [IE6 - Ecosistema DeFi e Interfaces]
// Importación de las interfaces y contratos base de OpenZeppelin.
// Estas importaciones son resueltas de forma nativa por Remix IDE al usar rutas de npm.
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title MicroCreditoColateral
 * @author Docente Fundamentos de Blockchain (BCY0010) - Duoc UC
 * @dev Contrato pedagógico para la Evaluación Final Transversal (EFT).
 * Implementa un sistema simplificado de microcréditos DeFi donde el prestatario
 * deposita Ether como colateral a cambio de retirar tokens de prueba como préstamo.
 */
contract MicroCreditoColateral is ReentrancyGuard {
    
    // --- Participantes y Roles ---
    address public owner;     // Administrador/Prestamista del pool (dueño del contrato)
    address public borrower;  // Prestatario actual que ha tomado el crédito

    // --- Estado del Préstamo (Máquina de Estados) ---
    enum EstadoPrestamo { INACTIVO, ACTIVO, PAGADO, LIQUIDADO }
    EstadoPrestamo public estadoPrestamo;

    // --- Variables de los Términos Financieros ---
    IERC20 public tokenCredito;       // Interfaz del Token ERC20 usado para el crédito
    uint256 public montoColateral;     // Cantidad de Ether depositado en garantía (en Wei)
    uint256 public montoCredito;       // Cantidad de tokens otorgados en préstamo
    uint256 public timestampLimite;    // Plazo máximo para devolver los tokens y recuperar el Ether

    // --- Eventos para Auditoría y Trazabilidad (IE5) ---
    event ColateralDepositado(address indexed prestatario, uint256 cantidadEth, uint256 cantidadCredito, uint256 limiteTiempo);
    event PrestamoPagado(address indexed prestatario, uint256 cantidadReembolsadaEth);
    event GarantiaLiquidada(address indexed liquidador, uint256 cantidadEthLiquidada);

    // --- Modificadores ---
    modifier onlyOwner() {
        require(msg.sender == owner, "Error: Solo el administrador puede realizar esta accion");
        _;
    }

    /**
     * @dev Constructor que establece al desplegador como administrador del contrato y define el token de crédito.
     * @param _tokenCredito Dirección del smart contract del token ERC20 (por ejemplo, MockERC20).
     */
    constructor(address _tokenCredito) {
        // [IE5 - Wallets y Llaves]
        // Se utiliza msg.sender para registrar de forma inmutable a la cuenta/wallet que firma la 
        // transacción de despliegue del contrato, otorgándole el rol de administrador (owner).
        owner = msg.sender;
        tokenCredito = IERC20(_tokenCredito);
        estadoPrestamo = EstadoPrestamo.INACTIVO;
    }

    /**
     * @notice Permite al Prestatario depositar Ether (garantía) y retirar tokens de crédito automatizadamente.
     * @param _montoCredito Cantidad de tokens ERC20 que se solicitan en préstamo.
     * @param _duracionSegundos Plazo del préstamo expresado en segundos.
     */
    function depositarColateralYTomarCredito(uint256 _montoCredito, uint256 _duracionSegundos) external payable nonReentrant {
        
        // =========================================================================
        // ANDAMIAJE PEDAGÓGICO - COMPLETA AQUÍ LAS VALIDACIONES
        // =========================================================================
        
        // TODO 1: Validar mediante 'require' que el préstamo esté en estado INACTIVO.
        // Pista: compare la variable 'estadoPrestamo' con 'EstadoPrestamo.INACTIVO'.
        // Tu código aquí:

        // TODO 2: Validar mediante 'require' que el prestatario envíe Ether como colateral.
        // Pista: verifique que 'msg.value' sea estrictamente mayor a 0.
        // Tu código aquí:

        // TODO 3: Validar mediante 'require' que el monto de crédito solicitado sea mayor a 0 
        // Y que no supere los fondos del token de crédito que posee este contrato inteligente en su balance.
        // Pista: use 'tokenCredito.balanceOf(address(this))' para consultar el balance del contrato.
        // Tu código aquí:

        // TODO 4: Validar mediante 'require' que la duración del préstamo sea mayor a 0 segundos.
        // Tu código aquí:

        // =========================================================================
        // REGISTRO DE DATOS Y FIRMA DIGITAL
        // =========================================================================
        
        // [IE5 - Wallets y Llaves]
        // msg.sender representa la dirección de la wallet que firma digitalmente la transacción.
        // Se asocia automáticamente esta dirección como el prestatario ('borrower') legítimo del contrato.
        borrower = msg.sender;
        montoColateral = msg.value;
        montoCredito = _montoCredito;
        timestampLimite = block.timestamp + _duracionSegundos;
        estadoPrestamo = EstadoPrestamo.ACTIVO;

        // =========================================================================
        // TRANSFERENCIA AUTOMATIZADA (IE6)
        // =========================================================================
        
        // [IE6 - Ecosistema DeFi e Interfaces]
        // Interactuamos con el estándar ERC20 llamando al método 'transfer' sobre la interfaz del token.
        // TODO 5: Complete la transferencia de los tokens prestados desde este contrato hacia el prestatario (borrower).
        // Pista: llame a 'tokenCredito.transfer' pasando el destinatario y el montoCredito. Use require para validar que retorne 'true'.
        // Tu código aquí:

        emit ColateralDepositado(borrower, msg.value, _montoCredito, timestampLimite);
    }

    /**
     * @notice Permite al Prestatario pagar su deuda devolviendo los tokens ERC20 al contrato para recuperar su Ether.
     */
    function pagarPrestamo() external nonReentrant {
        
        // =========================================================================
        // ANDAMIAJE PEDAGÓGICO - COMPLETA AQUÍ LAS VALIDACIONES
        // =========================================================================

        // TODO 6: Validar mediante 'require' que el préstamo esté en estado ACTIVO.
        // Tu código aquí:


        // [IE5 - Wallets y Llaves]
        // TODO 7: Validar mediante 'require' que quien invoque esta función sea el prestatario (borrower) original del crédito.
        // Pista: compare 'msg.sender' con 'borrower'.
        // Tu código aquí:


        // TODO 8: Validar mediante 'require' que no se haya superado el plazo límite de pago.
        // Pista: compare 'block.timestamp' con 'timestampLimite'. El tiempo actual debe ser menor o igual al límite.
        // Tu código aquí:


        // =========================================================================
        // DEVOLUCIÓN DE FONDOS Y TRANSACCIONES DISTRIBUIDAS (IE6)
        // =========================================================================
        
        estadoPrestamo = EstadoPrestamo.PAGADO;

        // [IE6 - Ecosistema DeFi e Interfaces]
        // Para que esta transferencia funcione, el prestatario debió haber aprobado (approve) previamente
        // a este contrato para gastar sus tokens por la cantidad del crédito.
        // TODO 9: Transfiera de vuelta los tokens de crédito desde el prestatario (msg.sender) hacia este contrato.
        // Pista: use 'tokenCredito.transferFrom' con origen (msg.sender), destino (el contrato) y montoCredito. Valide con require.
        // Tu código aquí:

        // TODO 10: Complete el reintegro del Ether (montoColateral) de vuelta al prestatario (borrower).
        // Pista: convierta a 'borrower' en payable y ejecute el método '.transfer()' pasando el montoColateral.
        // Tu código aquí:

        emit PrestamoPagado(borrower, montoColateral);
        
        // Restablece el contrato para permitir nuevos ciclos de uso académico
        _resetPrestamo();
    }

    /**
     * @notice Permite al administrador (owner) liquidar la garantía (Ether) si el préstamo expira y no es pagado.
     */
    function liquidarGarantia() external onlyOwner nonReentrant {
        
        // =========================================================================
        // ANDAMIAJE PEDAGÓGICO - COMPLETA AQUÍ LAS VALIDACIONES
        // =========================================================================

        // TODO 11: Validar mediante 'require' que el préstamo esté en estado ACTIVO.
        // Tu código aquí:


        // TODO 12: Validar mediante 'require' que el tiempo límite para el pago del préstamo ya haya expirado.
        // Pista: compare 'block.timestamp' con 'timestampLimite'. El tiempo actual debe ser estrictamente mayor al límite.
        // Tu código aquí:


        // =========================================================================
        // EJECUCIÓN DE LA LIQUIDACIÓN
        // =========================================================================
        
        estadoPrestamo = EstadoPrestamo.LIQUIDADO;
        uint256 colateralALiquidar = montoColateral;

        // TODO 13: Complete la transferencia del colateral acumulado (montoColateral) en Ether al administrador (owner).
        // Pista: convierta al 'owner' en payable y transfiera el monto total de la garantía.
        // Tu código aquí:

        emit GarantiaLiquidada(msg.sender, colateralALiquidar);

        // Restablece el contrato para permitir nuevos ciclos de uso académico
        _resetPrestamo();
    }

    /**
     * @dev Restablece el estado de las variables internas para fines de reutilización en el laboratorio.
     */
    function _resetPrestamo() internal {
        borrower = address(0);
        montoColateral = 0;
        montoCredito = 0;
        timestampLimite = 0;
        estadoPrestamo = EstadoPrestamo.INACTIVO;
    }

    // =========================================================================
    // MARCADORES CONCEPTUALES PARA LA RÚBRICA Y EVALUACIÓN FINAL
    // =========================================================================

    // [IE9 - Rol de Oráculos]
    /*
     * ANÁLISIS CONCEPTUAL: ¿POR QUÉ SON CRÍTICOS LOS ORÁCULOS EN ESTE CASO DE USO?
     *
     * En este contrato escolar, el valor del colateral (Ether) y el monto del crédito (Token ERC20) 
     * están fijos al momento de depositar y no varían en el tiempo dentro del código.
     * En un protocolo DeFi real de producción (como MakerDAO o Aave), esto representa un riesgo financiero extremo:
     * 
     * 1. Volatilidad de Precios: Si el valor de mercado del Ether cae significativamente respecto al token prestado, 
     *    la garantía podría valer menos que la deuda. El prestatario preferirá no pagar y el sistema acumulará pérdidas.
     * 2. Integración de Chainlink: Para solucionar esto, el contrato debería consultar un oráculo de precios 
     *    descentralizado (como Chainlink Price Feeds) para obtener la cotización ETH/USD en tiempo real antes de:
     *    - Validar que el valor del Ether depositado represente una tasa de sobrecolateralización mínima (ej. 150% del crédito).
     *    - Habilitar una función de liquidación pública dinámica si el Loan-To-Value (LTV) cae por debajo del umbral de salud.
     * 3. Manipulación de Precios (Flash Loans): Si se usara un pool local de intercambio como oráculo sin promediado de tiempo, 
     *    podría ser manipulado. Los oráculos descentralizados resuelven este problema al agregar datos de múltiples fuentes externas.
     */

    // [IE11 - Marco Normativo y Ético]
    /*
     * ANÁLISIS CONCEPTUAL: LEY FINTECH CHILENA (N° 21.521) Y DILEMAS ÉTICOS EN DEFI
     * 
     * 1. Ley Fintech en Chile (Ley N° 21.521 - Promulgada en 2023):
     *    - Custodia de Activos Virtuales: Este smart contract actúa como un intermediario tecnológico autónomo que retiene
     *      el colateral en Ether. Según la regulación de la CMF, las plataformas que custodian criptoactivos para terceros 
     *      deben inscribirse en el Registro de Proveedores de Servicios de Fintech, contar con garantías operativas, políticas 
     *      claras de segregación de cuentas y cumplir normas de prevención del lavado de dinero (UAF).
     *    - Intermediación y Captación Financiera: El otorgamiento de créditos mediante pools automatizados desafía la normativa 
     *      bancaria tradicional, ya que no existe una entidad jurídica visible que gestione los fondos, sino un código en Ethereum.
     * 
     * 2. Dilemas Éticos en la Programación DeFi:
     *    - Liquidación Algorítmica Inflexible: En caso de congestión de la red blockchain (incremento súbito de comisiones o "gas fees"),
     *      un usuario vulnerable podría no lograr que su transacción de pago sea procesada a tiempo. El sistema lo liquidará 
     *      de forma automática e inmutable, despojándolo de su Ether sin derecho a reclamo o mediación ética humana.
     *    - Sesgo en el Acceso y Exclusión: A pesar de promoverse como herramientas de "inclusión financiera", los modelos DeFi 
     *      de préstamo colateralizado requieren poseer capital previo para ser beneficiario de un crédito. Esto reproduce brechas
     *      sociales de riqueza, favoreciendo la especulación y limitando el microcrédito productivo a sectores de bajos ingresos.
     */
}
