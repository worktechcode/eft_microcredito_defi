// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// [IE6 - Ecosistema DeFi e Interfaces]
// Importación directa del contrato base ERC20 de OpenZeppelin.
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title MockERC20
 * @author Docente Fundamentos de Blockchain (BCY0010) - Duoc UC
 * @dev Token de prueba para simular el otorgamiento de crédito en el laboratorio.
 * Permite acuñar tokens de prueba a libre demanda para facilitar las simulaciones locales.
 */
contract MockERC20 is ERC20 {
    
    /**
     * @dev Constructor que inicializa el token con nombre "Token Credito Prueba" y símbolo "TCRED".
     * Acuña 1,000,000 de tokens al creador del contrato para fondear el pool inicial de préstamos.
     */
    constructor() ERC20("Token Credito Prueba", "TCRED") {
        // [IE5 - Wallets y Llaves]
        // Acuñamos balance a la wallet que despliega el contrato (msg.sender) para que actúe como
        // el fondeador del contrato de préstamos.
        _mint(msg.sender, 1_000_000 * 10**decimals());
    }

    /**
     * @notice Permite a cualquier cuenta acuñar tokens de prueba (simulación de faucet).
     * @param to Dirección que recibirá los tokens.
     * @param amount Cantidad de tokens a crear (en Wei de token, 18 decimales).
     */
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
