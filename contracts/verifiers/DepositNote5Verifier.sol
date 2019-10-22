pragma solidity ^0.5.2;
import "./VerifierBase.sol";
// This file is LGPL3 Licensed
contract DepositNote5Verifier is VerifierBase {

    function depositVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x1f0d4ab681e60a0868d58f162d59df9f1b488777fa29c3e33ffa079e09b19658), uint256(0x094d3e1390a55cd2e111d11e0f597c9a1d1b8641a8e17836094292ce93a35aef));
        vk.b = Pairing.G2Point([uint256(0x01577a7077a3b575f61a47d0258570dc0895a7390d96e2f63ca93297903a804c), uint256(0x11877437f84a379d5e04dfd34b547c63ef454ed7aaf27cba127422dffec2a138)], [uint256(0x29549edfb52ddec31ca1fc740da801e2c1a778d7673e206c2621a051d335fb5f), uint256(0x2d74adf493c430b4ea75a6d4a66a538b52a8c4bad53dab7417e0b067083c1c1c)]);
        vk.gamma = Pairing.G2Point([uint256(0x27447b8d95c37e550c0ec3babbbfd5dd14e61e8d748f85bb1fe3b0917ae1e3c2), uint256(0x295df8a10e8301620b7cf3d054baba1d794867bdb8da7f8fb2ea716f781f3c15)], [uint256(0x060f28a3ff280debb78d02db46713f966cb292068755324704b709a2143ac44c), uint256(0x1bb9454a9e9495df0c1a7c09f6e4516cb56f6838d44eac8a0f6d5ce68bc9f00c)]);
        vk.delta = Pairing.G2Point([uint256(0x2c3cc514f4c54605e0db4c55305735fc6d91cc044475eaf2f84e799cccb29c28), uint256(0x0455f56f01a3f0cd59fc42009c86ecb24045fb0bc2c9067e96bad450eeeb813e)], [uint256(0x1df0162fe8021873f960b297be9b157acdc328e2d862268690d5ece8afa1e6e9), uint256(0x0e2d38de0c8aac6edbf71b371fc46418d304ee27a02053798c6841ab185a1778)]);
        vk.gamma_abc = new Pairing.G1Point[](32);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x15c725042916527ced47e384abb239e00cc2c5aa1ad0e8af6bc233ccf46019f7), uint256(0x0aa31a601d9fece85bdfd55dddba418b86a935afc084faf8b9a47760de8d81d9));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x08903755466849c2d924d9f9cf6f2032c9ad9da0dfff9fb22caa53eb22b76c31), uint256(0x2d0e9602a5a199aaffcb71c46514d2cf9038c3c631410a57e495fcc7333748c6));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x2710123d27d5b93858672a3aab5edb39b6346f8060ce5d619d540e2ad26ce7f1), uint256(0x08446f02f832d6604c37f5b3497537037c69e7cbc8fec136a202cb22c363a1ad));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x2e63ab0d75b09e637391b43e2470e350df01159bae7b8e3049fa253269d6616e), uint256(0x0867534e2a6cd966084643f9d24f104c6ed2e91458e85ccb95b71fb822ee522a));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x221718c12e7aa360fd67ef8cb27bdcadc1ced3caef2ad5226ed9b4340982c670), uint256(0x191ac05af5046528d071939680e479b35fb0de7a99fbaa3cf2d8cf715623d861));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x08954431ff5d354d08c7f205ecf57da3aa1813bfdbe7341331d74ee9bca4e6a9), uint256(0x09c1268ad32e21bf8c402d7371b32d438ec798028684eb6e1f78a334c25f4226));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x2ff072628fe9dd7eac9512299ce84bcc2619c89025174dc0eefdeb1c2bec8723), uint256(0x1e0e879a741248e07d6e9f0e4d308edd5b578209b7061ed7197c327e3a2d4bbd));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x23935bdf628478f5b4892a713774e3e8bb40213e727af025e295cfde7caffe72), uint256(0x2670ec0b562a9e67f51893bb0d669eeaf311323d188924afd68ba7a688243a69));
        vk.gamma_abc[8] = Pairing.G1Point(uint256(0x2274fba3179146eca122ce4d0b05b05d833171e1ac66ea95f00e7e31e35589fd), uint256(0x11087ef307c51eee2387b325bf37fd493ff289633c4169f4c63092588e736748));
        vk.gamma_abc[9] = Pairing.G1Point(uint256(0x011bd60ee68c95e5535be63d0a85456874cdb6020553f9046227d8da12955cef), uint256(0x2baa1dab3e23831058024fdb98dfddc960613c48efbd33add8ebeb04ae8133b6));
        vk.gamma_abc[10] = Pairing.G1Point(uint256(0x0986d95d52f31156748f0bb378cfc8dd66e53e71394c24c5a5b982dd4ce5b051), uint256(0x241c2f876c4bc7e1b715b01037b1af265516f27a30b4544edeb41241b3513a41));
        vk.gamma_abc[11] = Pairing.G1Point(uint256(0x1fe93c7de253a68a5351ec602e5cc48f7ba15c4727b8be2766182ff8ed9b6c8b), uint256(0x06bf82e7f7c81ba72257dd2be8afe79ffab9a53dff603265cf13b29db0083572));
        vk.gamma_abc[12] = Pairing.G1Point(uint256(0x1a5f3685a767dd8caae04e779eda42330397eb673a238cbe48b3be2d735c8f7d), uint256(0x0a90556c0bc895178fa4915c6410dc40fe3d443ee7d67191952410ea27a70255));
        vk.gamma_abc[13] = Pairing.G1Point(uint256(0x118af77ba8f5e82595433954156d0b089fbd58eabd1f40176c4878632c380eb2), uint256(0x1fca1e76d957f1231c02aa82782d5c24b89ac3a08e569fdda2ffb3dde32b1d18));
        vk.gamma_abc[14] = Pairing.G1Point(uint256(0x04161e8de8a2fbdffb70435294044f2e7e99a2c760bdbee3a94235a28a9b8958), uint256(0x0ba4dde5f3a13cf6e4375dcd6117cf308533c16f61eca662fb359ac7d8e47c5f));
        vk.gamma_abc[15] = Pairing.G1Point(uint256(0x0be51158dcf915f0503f93754342321beb6dd9b88503fe907c1ca8b69ef1747a), uint256(0x200dc4e32df2457d8d2c5101799ad6c075b8a0afe0045e8570660f690d3c7936));
        vk.gamma_abc[16] = Pairing.G1Point(uint256(0x2954353c75eef652e357a453b20f022091a8072f39b53c9184964ab82b4d2fc0), uint256(0x16245e9cd195266effaf7c5268086f16e781e4bc97fffff1e3fc4bcf18e89e18));
        vk.gamma_abc[17] = Pairing.G1Point(uint256(0x26bf4420ecd05beb5c46cdb60fd3281772917eeec9be0fe50f198d4ecb3be660), uint256(0x289b7b93f8da4eeeeabd305793812dc29cf4dcff32599c21ee9c7457635b82a4));
        vk.gamma_abc[18] = Pairing.G1Point(uint256(0x204ca7e50bdb4628082be6bcb8907f1fef40ed407682b7ca9cec563d0ad52e3f), uint256(0x28de6ccecfd30de76df6d531972a3f3bd92d46668bef7b69ab7bdc0f1748c5d0));
        vk.gamma_abc[19] = Pairing.G1Point(uint256(0x1e9e7ee8d4547a89dc0120b60e71632096a95629896818af22f67eef0afd634c), uint256(0x2324b6153e5446cc58690d00616cb2774d2081a89b8b63b0c268fa71e8fa573a));
        vk.gamma_abc[20] = Pairing.G1Point(uint256(0x1a31cb6bd35059d178dab115e7f61db6871c57e4c8a7d9a93de0502ab2ace285), uint256(0x2febfe21ece710b719d43df75ccb3db83ba0b8a2ae07b104caa1e6f0060982ec));
        vk.gamma_abc[21] = Pairing.G1Point(uint256(0x269f99c3902df2b70c2f517b66edf06cb3a523e17271733cd7b8081628a53de0), uint256(0x24daa4de591854c330f9e241a086fb576825fb06adf991459407546730c1caee));
        vk.gamma_abc[22] = Pairing.G1Point(uint256(0x1c510e1ee0f5d5fdbebc8e51416bed6959ab93f50199c50bf173cece18c6caa0), uint256(0x1386f1c3b9a6963c511747a49f71a32276a7a87bcf55fb56017acdad45486ae2));
        vk.gamma_abc[23] = Pairing.G1Point(uint256(0x1c78cf549cbac7117e8c275762a0e23295db9780bc693ad0d02427a1efd3830b), uint256(0x020c3228bb37578e77c22b8e51651af9bbf77298d558f21c0444ca7536ff6fbe));
        vk.gamma_abc[24] = Pairing.G1Point(uint256(0x2439064b9c62b37e1777d586f35e40dccbfbfe6ffe1551d26c50087940288135), uint256(0x129612989d3b99a7e283c597392cc1df31ce6e5122b75356564e9d8ccbc760bb));
        vk.gamma_abc[25] = Pairing.G1Point(uint256(0x266451dd58da04ed176ab2d1bcf9b2dba12c735730b24d256f43398eeaf47bf6), uint256(0x05dc13989cd02c3e2cb2e6928b64c40b6bddfb1dddaef20288bab97e3664df8c));
        vk.gamma_abc[26] = Pairing.G1Point(uint256(0x276b603dfa2c3d310ac6328bea22daca9b708a947d559aebee40c60301c3c23a), uint256(0x1b8ff2fc48e77aff179ae31299ed835398cb250670c6ec2710921da05bc6eca1));
        vk.gamma_abc[27] = Pairing.G1Point(uint256(0x1374f8bec7b5d4581df9a0243d1d835f7d339b1e99ee6e9c79e4d8bc2e8d8fd8), uint256(0x094436f6d94638e713389a682de1b4da0caa42d4f8380cc94b72c0d4cc041a66));
        vk.gamma_abc[28] = Pairing.G1Point(uint256(0x20f518b0459f59ea7154bce92239d6c43abb9691272fb9e992e841c2290f41b7), uint256(0x084d68d22fbfa1aa4833e6873e0fb11e2beacca61d8013d3ccb191cb50ee51e3));
        vk.gamma_abc[29] = Pairing.G1Point(uint256(0x2ccc1b62edbb04300af37eeb5a5948d2c0507a742e933ea111b89897b4825221), uint256(0x20a493397ad16904e39ed6366619752e59b6ce3e13254abf61bc086140a0609e));
        vk.gamma_abc[30] = Pairing.G1Point(uint256(0x04916233590a4dd7a5344e4e4134b33c8deb88f6f3393f378f077b94a6f65e65), uint256(0x1fdb9236c0c0204bd43909c60c31f425c663a9cd917d4c7b9e0a9cac99a473de));
        vk.gamma_abc[31] = Pairing.G1Point(uint256(0x2085528fc3ab253e5fc937ef0038458a53af530ad299b77be6dfd84646d7d52f), uint256(0x0728c0336066383869709b8b3f4fca9ce15037066de972b7991cb14fb73312de));
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
            uint[31] memory input
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
