pragma solidity ^0.5.2;
import "./VerifierBase.sol";
// This file is LGPL3 Licensed
contract Verifier is VerifierBase {

    function depositVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x292e405eafc6bb584d54f265fcbedace22f98357e05fad3f0bd6dd4e692bdaf1), uint256(0x208c9dfd9c198c6e4266c42deed23783c2d66e36dc0b8d0d07dc9309c59e0fd7));
        vk.b = Pairing.G2Point([uint256(0x3018c378667de8a6bbf22edc67e82cf540fff2d0f553f8f2732e889b0a23b159), uint256(0x1897e8b22f6206eefef48e621f98dc92a498f0bc70f342e1fe9f5107b1d318e7)], [uint256(0x267c90cbd333c98d44b76f76ada4d96be3a9fb832f64d589dea8d805dd5786de), uint256(0x05cf02b0769e7e4adca45cdf6c5cff14c9f0e2813a1766c4c401704b60c7c742)]);
        vk.gamma = Pairing.G2Point([uint256(0x2b6a325e820f1233201f8d9a96f2a717a212d3ce6a7e40ddfc6fb44a91781495), uint256(0x07667a84db9f50f13b90474c272792aef2695983683f8640a81efb8ec26fea91)], [uint256(0x02dcae9d61a2a4571c606cd2d68088ce8962e525ffad9050ec7889e6d91315f5), uint256(0x13c5004d4f8155c12c0a7b796ca7a05373d3762d8a83f99075a141f0221d8b26)]);
        vk.delta = Pairing.G2Point([uint256(0x228f6c01bf212813f0d577467419a73bae50702925e7d7d4981f44d043409ad3), uint256(0x26962d87cc717c4deef522c6e7b5878a264b8c436e02c06abc551fef7ea284ab)], [uint256(0x1ceca2434cd02c24c77c73cd55adac93493b1ba5584ece92123ca271ca1222c8), uint256(0x2e33b906f8990c9752bdf2823ab7ad45aa13e7e8a265ece3e804e93d08ab46aa)]);
        vk.gamma_abc = new Pairing.G1Point[](20);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x0457295588488bf3449a94a37e47fee1b398cdbd46179d131e2f7b62b80caf97), uint256(0x20082d5bba62f009543fb9e9fd08d4286d49e9970e8e6ffcbed52482872cf3c9));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x27d1807ec9db0db89e21fac47a46b7ab7b1d6becc582dbd8efe18c137fefd55a), uint256(0x05322106d35dd78333c19e059dc472986088f1f18b29b7319d5d6322447f37fa));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x23c772e9cb9b2052c409578b871d4ed255d0f739400c755f4775da6563fb8b66), uint256(0x18f1a5eecafa8a8d79ea488a8b88729caefef610d72f84b0d67ed2f4cd34b2cd));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x2110f6298f88dc6235e3eb7801b269402af8e46f428a346cf1a095477dee1b93), uint256(0x0f71e1eb6509cfff1956a21ad488a260414cadec9dc9a97030d99ca71e83afaa));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x2a12e5241240e86cbf2ac03357e97ee94651270617676ecd4289a229e3305456), uint256(0x1ab0c4688b0cdc039fae0b97bcd1a1cb8b861603076a7db9bf56fd46607f5114));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x19f25c91b30a5ae95a9f8b93b2cb0c23cebca4aa1090d61dc83db8355c17dd72), uint256(0x0dffe15483f457409926d2d38758e45ded7045b184eddb7a2e49d407bdc47d7b));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x2b13730b689bb08dba77382cff6885e9703d2038df1b588155b00e121c10bffd), uint256(0x234f57591efba25096237fb6509b797d05e7489f99614ca693861baaa472753e));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x1088200be3c0bb23c3845cf1980218c11e30e72bb4b9ea2cd343b991eaded6dc), uint256(0x189bb7dbadb81f4cac15ba46510c281bafa90fcbaea973084493dd2367c654e5));
        vk.gamma_abc[8] = Pairing.G1Point(uint256(0x033c94bfa0f15b097fd2a4035ad63f3ac0d143193ad037d394cc623017e3c5bc), uint256(0x018659da5ab47605afdaaee9e97b645b674aab3b536eda61f3685930599f964e));
        vk.gamma_abc[9] = Pairing.G1Point(uint256(0x25bb8751267e43637cea9c66cec492dca4468a1271467cda9d8eba504b5be0a3), uint256(0x2fefa658d181b568588ba065220d811f69225159b6862e86303420c311cb76b3));
        vk.gamma_abc[10] = Pairing.G1Point(uint256(0x2878262189e18b747b1754fab7eff743301b77ee4e506641ac066ccb174858c1), uint256(0x1f183d8bc74d2fcaac8e86738856a9f215af98ab25db241d099dff5f779e61d0));
        vk.gamma_abc[11] = Pairing.G1Point(uint256(0x0e5fe16b780cd68ea60fc5e3fe470e0b478616f576b5fba2443588de397be2cd), uint256(0x19bfa1527071ba45652ddf893225b1f87756a4cea620f1d5ad44d0f2b6d6a3e5));
        vk.gamma_abc[12] = Pairing.G1Point(uint256(0x2ad98f589f4c3278013d8aa813c280c6ba9b0edabac6e852f15e4d1799d69368), uint256(0x210e954fdecb5c67acd836816023a4f3cb798f8c2ca21f06efc672c876ff1a99));
        vk.gamma_abc[13] = Pairing.G1Point(uint256(0x25069a945d4a92386cb91187c7e79e30036a9a19cb3c4aba1ecb933d48f75691), uint256(0x27024885a51fbc7fdc69a55fc27b44f7a9a0ba95dcec195deee0a00c146c3f5c));
        vk.gamma_abc[14] = Pairing.G1Point(uint256(0x005f22d6004c702dcf85d1d57bf71e0838bba0b8eed81f7152c140d113e03667), uint256(0x2663f49397b622cbac15470f03ac5ec004744bd043c55498b925244e1446277f));
        vk.gamma_abc[15] = Pairing.G1Point(uint256(0x14918663841b13b7b6c43fa031e187f985027e2091e3f619712046d323ae9edc), uint256(0x0e07f5b147ba87781d8fd87582bc8ec4071a22e59d167f715acb3ed6c8d21c0a));
        vk.gamma_abc[16] = Pairing.G1Point(uint256(0x1eda80c036a1ae50f079ce7f7293aebaaca918503036bb7edfaf34d3f9d44371), uint256(0x2439540350b6a9dc60181cd9de0780d69385ddc4415b0df3ca1417db878900d9));
        vk.gamma_abc[17] = Pairing.G1Point(uint256(0x13cc1105d0148340ff3079ee1e116f59bffbcac8a7968afeef0d7b9eae5615dd), uint256(0x18651af543cd0a5a9434426269b49c75b062c2fd4c9cbb488be23656a0cd64a9));
        vk.gamma_abc[18] = Pairing.G1Point(uint256(0x2a6084bbbd99b96db2af54e1309746d609a9ff3f1ec320fcf116c8cf3a256b3b), uint256(0x08572aa30446b6a7bd5604bd7ca6c0725df357a9192b64ba1878ed4bb8568738));
        vk.gamma_abc[19] = Pairing.G1Point(uint256(0x2d79500232d03709ba8b8cdec7a181413a4266f8cccedd0b6a6d8ceb8fbeeab3), uint256(0x1ee05f8ade011c47a1cce063b5aabc8465b6edcac1923908ccae7c88e1cc97ae));
    }
    function depositVerify(uint[] memory input, Proof memory proof) internal returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = depositVerifyingKey();
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
    event DepositVerified(string s);
    function depositVerifyTx(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[19] memory input
        ) public returns (bool r) {
        Proof memory proof;
        proof.a = Pairing.G1Point(a[0], a[1]);
        proof.b = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.c = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (depositVerify(inputValues, proof) == 0) {
            emit DepositVerified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
