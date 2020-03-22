pragma solidity ^0.5.2;
import "./VerifierBase.sol";

contract MintNoteVerifier is VerifierBase {

    function mintVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x2ac7d9aa9121b063ee14dfd31ba79f34a2376491cac4308f8b617ca7587cd7b4), uint256(0x08205d5b70313b64d5c68227e740529d07ca9ab4a9b19883645813c8617d8820));
        vk.b = Pairing.G2Point([uint256(0x1034a1b6b3c098b8228be641f966d57ea70dc5c1227d6bf52a5f0586c76bc8f0), uint256(0x1d3cdaebb4bf57dcbdcde6f782450acf058ee24edd46c74a563ba8cc61a7105c)], [uint256(0x01ba065b42668bdb64cb03b9fb9edc49daeb351a4a49056cc6cc5a51543b979f), uint256(0x0073d99a1f08094362f068a85e1ee4158f621fa458169207fe9173c2edbdd122)]);
        vk.gamma = Pairing.G2Point([uint256(0x0e4072b137b2c920ef328dca38f1c786f2356c13313aca775f0cdbee46551472), uint256(0x100d95773fa8ad6e8f323a1800f8393b085bbc21802b50d055b6c2a39aef2bcc)], [uint256(0x19e97719e9ca0075b7dfb27c806c23ba9957dd2f2c84d8bb1a5ea1aff31ee79a), uint256(0x1cdfce5a35c7f4018e1fdddd768928e253f5db2e7233614c9e1b7165cf0b6d07)]);
        vk.delta = Pairing.G2Point([uint256(0x29fba4398196d36c6626f94b7c5dc7ca52476da2d6a611d5dff2f1d6adfee2c1), uint256(0x14f79bf04e76ff816cf33d57e0f9cc9bd11e3f7668cb36a7bc4bf1d7876e8b4b)], [uint256(0x190309946ddcf285c0998b5672a047f8d0baf5bc47f03a0fb7fd2d655b5a3152), uint256(0x14c0234eed820722bdc87192cda51fe36aadd429fcfe21c0b63ee94ce6a5dd1a)]);
        vk.gamma_abc = new Pairing.G1Point[](6);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x164f38af196c31beb6c6450309dbe4ac0046bd12408e2f066852797aaa56f7ba), uint256(0x0d2ee0eefdf0b1342ddf49d597529a4b1c62a88891c71712fb5a8bb5cc99751c));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x23a742e83ecfd806dd26c82be645a84e74c1c6d0fc86e3c119581b1907f7eb15), uint256(0x1e4d17129e9bba490ce7449bb6771d7f11b9c34e8b59713c1d1524b45bcc20c8));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x2ac1a0abc97bd7f2071760e9fa3b858343d296e5a1f101e5b2cb0df3d1244c54), uint256(0x0deba4ab5e16732914d2ff5c3e5e473650538620b9faa96fa77490fe815da806));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x05a785d34fcf4c486fe90302e12abfde796f3a55404a5bd275cda07d53400c0b), uint256(0x24f49df46b2e1683bf15973e87883cfe0cafba300840d388c0ccf439344de3aa));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x2db79dddbad8d9c3f597c828ff586558ed85edef3ccef8e5d78651c84bf6ffe4), uint256(0x0c1be9ef75f7ca63c595f1308a91e754a2b548978c63b7784c709db112bb2aa5));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x05bec0bf74e969cf2bde4a5ccca34dc0583d7e8774de502f540683e38094dd45), uint256(0x1c5a0c0b0ce73f7cb98dd2b442d49432407f519b4e0c9f83aefdfb064386f9c4));
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
            uint[5] memory input
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