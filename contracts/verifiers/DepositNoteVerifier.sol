pragma solidity ^0.5.2;
import "./VerifierBase.sol";
// This file is LGPL3 Licensed
contract DepositNoteVerifier is VerifierBase {

    function verifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x0a8edf29568df20e07158b51660a26fde923f126d04a108fc058304a6ac3bf23), uint256(0x1cf9a7afec58e67bf9f723dbe5e47a688e9cc5b20d14b34ca0ccc1d52cdb6058));
        vk.b = Pairing.G2Point([uint256(0x05866ea52192be095ea3eb6066db23da153db051df5ee8da7043d16e4f6def7b), uint256(0x16d0339084275459a870e558ff05f123b766dad96c81f38458eda9f1cb631e7a)], [uint256(0x040644de4c9e9e80a2787dbe4ee9708273d9648ef1ee2307ee0acff0d94fb351), uint256(0x2c631bf18f5b8966ce17bd9e18252f4a53d3b52af8393f3d0412a401d9567a33)]);
        vk.gamma = Pairing.G2Point([uint256(0x176a2b0a134088b37b26773181678e0856ab2772d90c2068ada45141a1a776d7), uint256(0x0a1980e32bae5d6d5f2680657f09ba7a3498ec9b266e005bc4020206f4faf107)], [uint256(0x11280f2f7a99401dec18b349370cce205d01d590d0ef93aeda94d00f7588c3ee), uint256(0x20e42718391ae934313a8beb2bcab047b995f3d32a117afb681cd17646873ff2)]);
        vk.delta = Pairing.G2Point([uint256(0x09df280a45a6605eda39e3e547e760f95b7c96d448914c7203f2de164f5127ed), uint256(0x2493ebf2589bd0c826ad33d25b7608c20a7dbb18da9ddaad5624630d9d015645)], [uint256(0x26cd15aeb0251fb527e766430ae5f7a14b56625eb50fa70db816a111dd84a059), uint256(0x197ff8ad8660c3d83e7701f04e230788cf1b68a6cab2d6d6819af5dcbf12af39)]);
        vk.gamma_abc = new Pairing.G1Point[](18);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x29c077606faf2f5ba06b448d2d2210c803fd6370857350a8da6eadee30acc723), uint256(0x287e7240f9c8f073f0d4da7ed25478862940b444f2e781e38efee8227e0c2abf));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x2ebce4c97bbc941dc0d92e20a190968a90f929bed9529729fdd75186539786d2), uint256(0x16e00ea93b4080f11f9cb1641a163f0d028dfb3e00c07d7d505d737342bc7479));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x1e777b2fbb9fcf2d369b65afb33e4a020007825a49e9881e5a0f322c573bfcbb), uint256(0x201743e61f0f13d6c1ee2c83b6446131c3b073b9c7c250bb89ceb1493fc899aa));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x1c176edca92819a24b622ebd1ca7f2587ae04670f6f1fada1c60ec72298c815d), uint256(0x292c18f91681016e14c699adeb3485c0d31ce66a6be1061c1f2df155d51a2e3b));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x08d91ad72312a3f92a5b553e33d392ad8de97aa6177f32f9ef4851d45168898f), uint256(0x2c3303f197ba5356d7aa7af653e80cf2ebb0289ced2330085a9fa1cd354cf253));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x2bf562e19295fafbbd38e8f96defb3712920e21bcf75047855d895543c604138), uint256(0x2eafda2b891ea62b2fa3d03c401c0aa138a4ff97e70c51955827f48c8163ecdf));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x025ffaba4b7bfdb3a4c147f206f7dfab92167b15debf50cdced04d6f45112976), uint256(0x1e91eb13788b91183da38a872b9876feccbeb74c3cad7fc81501fa0ab0131e44));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x1b5ca571bad825b11c303855853209153266e1a89a27f2e0a1af3de292a783ae), uint256(0x083af486d11f110f4dd26869df25b7305871773f74d14b3155b8ef60847407d8));
        vk.gamma_abc[8] = Pairing.G1Point(uint256(0x0c2b69fc854f99d572b30d528b72c6851138146396e7cdf95662987a272498ca), uint256(0x05599b23495042a833948c0569018e2dfe009b7f9b0ed427e52225bc114f8443));
        vk.gamma_abc[9] = Pairing.G1Point(uint256(0x28ed38975063378b0cb6e9f48e9f0485733dc43888f62a691b4716d41b4a5545), uint256(0x2c00903e8fe95f5d3a979e87da17fabeebd3f13a39bf542d7989bbf26407c57a));
        vk.gamma_abc[10] = Pairing.G1Point(uint256(0x281730ab818876a539b61079f7b0cce3c65f8651bbe44faf9ffbc235d44f4dab), uint256(0x29909bdffb7190eb0ae2427b40fca64728be7b2423bdc92808eedde14ca1edf4));
        vk.gamma_abc[11] = Pairing.G1Point(uint256(0x000a75ad1db1abd9718a1e59488cd632c3ad46707203025cb7e8c5025628a95a), uint256(0x1ad7ac3a61b1b8c4dedcb0470e43baa6d479391f50a2ff5584c3b7a0bc07e4fa));
        vk.gamma_abc[12] = Pairing.G1Point(uint256(0x1505ab374f4e2997120b1756b0e3b60b0ba89b2b391415842d484f49ae3f9e29), uint256(0x02c0f79b24806ae9f06f9bd654bb33c555adc26f5d022f0f2c89e4a5da3990ce));
        vk.gamma_abc[13] = Pairing.G1Point(uint256(0x14f6610ffcc6d3d06b1e35e5abfbd1000caf9f333274f4ba2fb296f32a783cab), uint256(0x2bca49f67994a4268df97d86dc064f9ad881f68ecfadaf264b676442ac98cf2e));
        vk.gamma_abc[14] = Pairing.G1Point(uint256(0x20f4ba392dcaf471d516516d66cae0a378cebd606fbf5f8ec563a593a291e761), uint256(0x116dd0a124ee5e9c0dcb0904fbc20243051542a6a616825a56fe88516f44bd54));
        vk.gamma_abc[15] = Pairing.G1Point(uint256(0x13dd6d3bbc2cea28b265f456dabd7bb74b758ce6c8b09edc8b64043c854e6851), uint256(0x170f85d34e3d991e1c5eb3f66281c2192496bdb5c5b7dae2ee1ecc5e25b0accf));
        vk.gamma_abc[16] = Pairing.G1Point(uint256(0x2be30c85d8e3c1d1d8a6b4570a6cc90b69fb77c3f25b4393a8e56070bf77cddf), uint256(0x26ad35b29cc8a1c97c4057dc9520502c5cb69830079707c54fb68e70c77bea63));
        vk.gamma_abc[17] = Pairing.G1Point(uint256(0x0c23b3097fd3f994d5c5727ea55a2232cfb7c0ecca736d662a37d578913559c1), uint256(0x03cc782d728dfa91d02d88aa3b7cb238c9091afcae4d763d9dc173a39ba35eb3));
    }
    function verify(uint[] memory input, Proof memory proof) internal returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = verifyingKey();
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
    event Verified(string s);
    function verifyTx(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[17] memory input
        ) public returns (bool r) {
        Proof memory proof;
        proof.a = Pairing.G1Point(a[0], a[1]);
        proof.b = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.c = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            emit Verified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
