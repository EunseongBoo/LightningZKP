pragma solidity ^0.5.2;
import "./VerifierBase.sol";

contract SpendNoteVerifier is VerifierBase {

    function spendVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x266537d47490eaad3f11c8c214f09ad85b10fc1140412c489f6bac0a92637295), uint256(0x29ce906501b052b6c62530a7dbf80f98c82829d7833d3b653a23290f915a0831));
        vk.b = Pairing.G2Point([uint256(0x1496c4a56cf0841dccba067b3474b72dc9546bc4b07c5871d4132e893658cded), uint256(0x052ce9563ee9b1935a91ff150e8bd6ef40b1e0f92c473fafddcc689a38798ca0)], [uint256(0x181c37b105c55b430cbe8477789e9d74c88e19c32db70e01cc3393c6d73175e6), uint256(0x10950198a872aec2ff5d14602eea1cc7bf5911cee26785e9fbdaa3100a71cea1)]);
        vk.gamma = Pairing.G2Point([uint256(0x16c832edd49a8812d54f4f9d189754dd6541d7201ad07cabbd7050a08d18568c), uint256(0x0062269baf3119b48f7084116c8c643cb623a2a77ec4993bdda89b395d052b0f)], [uint256(0x1a2bb376c369c717fc1cd334ab47c801b479d9b2b0a5c90e9e7fb7cc82fd4bbd), uint256(0x0293b00b2fd43a367853b4f8e79a4186c89c5d03f289f592951fa63b76698163)]);
        vk.delta = Pairing.G2Point([uint256(0x0b942a231f581bd140976d1c86a7341986007206481557cec6d27630e212a19a), uint256(0x1454fae8b1ad759873245137cfa16c5870088254c51caf0e393848ea3c6c75fa)], [uint256(0x2cd89491a4522fbe2e1cc13c9a03d7772c5629def3eae5fce3ce2105d268fc74), uint256(0x2b64ab398f910655b9a9a6b5953f2ac5ce82ffb7592b6c3a39326278451d512c)]);
        vk.gamma_abc = new Pairing.G1Point[](13);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x2a3c77dfccad375fc63c836ecf74b80ff3e3972f9ccae968831b162a32e97e39), uint256(0x036a74fec49419234b6fcec287ebda341a845fada6befdb4debc161761010785));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x1ff1b7e69f1d1925f5705182885d19551d5bbfbedfdce45871cde506e068c7bc), uint256(0x1f3edfbf1a2960c51e221d87c9c02cea1cae9d025a8533f2d2780920e8e930cb));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x287a5d20fb41b707b86110e544d6a993839e51c2c7935df6931b617738b81d48), uint256(0x0e475deeb5edb2e211ebf9d05587ccde0fb7c5b8b23ff7765f0495ac788a93ef));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x097ba34576b104a7ba650472803b02579450aa5b45ea241836c93cdb3e1bcc0f), uint256(0x0080d80877497a07cfd1dd0c48e1443e629d5b8b4f0c1ee24d5dcc085794244c));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x0edead7b22a0a2aa68898ed9a3f93b4aa817cfa269df4298d6f088145e1869a7), uint256(0x293eb69f6a20aca2a56aa4bcbdcdc9c3b2b0645d2c6b66cc0bd3a067a8323cea));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x03f5745aa4c4bcec32d70134bd86a7a40d1fa1a3f577a26a2df97e56df25efb1), uint256(0x1746060d154849e6e50236b67830372f90ecd82bc8e30f29d9f33ff466ac60f0));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x1f2e684be9ed7d9a8956039391674d1875741b9b822710caa65640a5a20d6a16), uint256(0x0116f5387c17e93629d33d91cc3194784d4341bc94cf94172c34218bec559145));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x0a22f82fe1f86ce3b766726d9af0a07286e90bc80804ef2366a3b828fb441eab), uint256(0x0cf73919f750ad4b065f6574829531143e99cf0c62db7dfe67e0290ba8f0c896));
        vk.gamma_abc[8] = Pairing.G1Point(uint256(0x20382b641fe2753c23aeb3eaf55f9277d402e4baa197c6f74c286ff0ec12a55d), uint256(0x13477dddbfdd13f6851cd716d46f074f00245437e40b3b7cbf3e25e4ab42f96c));
        vk.gamma_abc[9] = Pairing.G1Point(uint256(0x1da3f7924337a17a393ebbd26a050bfc4e9375938c6734b7dd2285e9b9014afe), uint256(0x18163ddc491e96bfc6d71975b32279d9d3414b7a07b157c18931606437fcd52c));
        vk.gamma_abc[10] = Pairing.G1Point(uint256(0x220b2a9be4ffc6a76223bcfbb5fb7678d24f4a505e53b4055abdcf315972c933), uint256(0x2bad9d783c8003296ea34d7511fd84aa55c851c05fbc6215fb6c21b1dfbbcc54));
        vk.gamma_abc[11] = Pairing.G1Point(uint256(0x22c88b9e03133eb80ea7f6b9d6466b56a2b7e3f9bbefc47706cfc1483ff40f49), uint256(0x104ffcc4957ba327f3e9165422c831e835361699635b297eb445f8c283ddd27a));
        vk.gamma_abc[12] = Pairing.G1Point(uint256(0x1d511a9972ff10970b600e5554168fefa88e82ce65f78e99453eddfdff483c22), uint256(0x2a8ebf9a91311df9e0560d06ca9210c71cebc11d1bde63f95049f3cd018f5b73));
    }

    function spendVerify(uint[] memory input, Proof memory proof) internal returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = spendVerifyingKey();
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
    event SpendVerified(string s);
    function spendVerifyTx(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[12] memory input
        ) public returns (bool r) {
        Proof memory proof;
        proof.a = Pairing.G1Point(a[0], a[1]);
        proof.b = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.c = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (spendVerify(inputValues, proof) == 0) {
            emit SpendVerified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
