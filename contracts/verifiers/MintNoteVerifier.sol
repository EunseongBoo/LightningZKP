pragma solidity ^0.5.2;
import "./VerifierBase.sol";

contract Verifier is VerifierBase {

    function mintVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x2d230435ed81e89d8e0a48208b7fcc9330775c37260245ebbf62b747ab3896b1), uint256(0x27723277bbf42d9ff40ff2c7eca1318c09729cfe72d68a1ece45be7e7a91252e));
        vk.b = Pairing.G2Point([uint256(0x227b38a6274edac4ce1b114d38dff05f37a3f27d630f0659a916d23409861924), uint256(0x266f2a8ece7d869b125214fa02eeb37082b4cf1ff6cc3a21eeeefc287b3a89ba)], [uint256(0x092103cce1d4e38aa89dd83a7fb490632fab17549e11458b3c78c5c498604a8c), uint256(0x004e93482d4333208b2455d0bdc57dcf08f56c94952acf0102e57cabe1633091)]);
        vk.gamma = Pairing.G2Point([uint256(0x08fc13c656dbdd7eeaac226e82682b9e1dbc98042089d479cb24d98cf48f4cbf), uint256(0x195ec16c3c6581a4809bbf7c88e4293fb2a8ca075a708d583578d49363ebef9e)], [uint256(0x1ef77e3ce1971994ee685b0d49658834358d8849762be160c11830c1a0c58926), uint256(0x28cca35656c2ba7ab4d94470df48b8ed6c337ae59a90c710f77ad4c421ec8bf0)]);
        vk.delta = Pairing.G2Point([uint256(0x02de3487c578091d38763c53b7a140c6aba4e26b9445055a890319d6ca0b39c1), uint256(0x2a467f8c8afdf9dc7e29e706a92a743f23dfc2d2443834b63d91991c13131114)], [uint256(0x0a0d152a3028b4c3ea719e856c541ed2666967c3d93fbacbf2f0ee69d96843bc), uint256(0x1edc8dd0b5afa5c2bd467f72bfcbb1cff2eb5eeb4ac1bdf65e4debfd10f437c7)]);
        vk.gamma_abc = new Pairing.G1Point[](5);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x01d06e6803123241d6d5a86720bf67c05ae719e0da4ed2bb3245158939665b85), uint256(0x295e9ddd9ed93bcf546215fb99716454cb3e5457dc2eed299a309b13c03168b4));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x179d3c0c35c9529e03dea9736a1003a5d7d47696a15f66b55efaa4fe252b9cf2), uint256(0x10cbeda377e8d21311326fac86b119a7afd0ecd92a9008a8a6fb477f36e61fd5));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x0a858384e95aac8721d737da3f82c4baa72de63c5f4d03947fe1cd496635d9a0), uint256(0x2550920274f4b612b19b2b7e8515fee246930d8d915403da5ad6fb9fcc6b57ef));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x0cc2dedee68da121243b09bdae6c7ef95e5570aa4151722157e8d90bcffdb0ca), uint256(0x0cdd0f9be81b131787ccb479894197f0949d1a30b92029242dd1f6bc6f9509c6));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x0272500928eb81b401bb5a6ec03640fd5e0cd8a63f5eaec768bc7bf950ab4df4), uint256(0x2ccff81ae6c5aad64bc96e30751d64e080c02a03c5cc2bba1c92d75366be99c8));
    }
    function mintVerify(uint[] memory input, Proof memory proof) internal returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = mintVerifyingKey();
        require(input.length + 1 == vk.gamma_abc.length);
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++) {
            require(input[i] < snark_scalar_field);
            vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.gamma_abc[i + 1], input[i]));
        }
        vk_x = Pairing.addition(vk_x, vk.gamma_abc[0]);
        if(!Pairing.pairingProd4(
             proof.a, proof.b,
             Pairing.negate(vk_x), vk.gamma,
             Pairing.negate(proof.c), vk.delta,
             Pairing.negate(vk.a), vk.b)) return 1;
        return 0;
    }
    event MintVerified(string s);
    function mintVerifyTx(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[4] memory input
        ) public returns (bool r) {
        Proof memory proof;
        proof.a = Pairing.G1Point(a[0], a[1]);
        proof.b = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.c = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (mintVerify(inputValues, proof) == 0) {
            emit MintVerified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
