pragma solidity ^0.5.2;
import "./VerifierBase.sol";

contract Pour4Verifier is VerifierBase {

    function verifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x179978e887ec69f80406124e959adc9aa0a811c0c7371d88eda9881572143c82), uint256(0x16e1bc75381567286adbfbb907805f13663ec3a420b2717680e439547c9acc6a));
        vk.b = Pairing.G2Point([uint256(0x11211e79743d44f917eb500334ef74f4ad8fee186c84adf21770b93e7ed94d21), uint256(0x21d99030c6a84edca9280b0d75634e0cd7de0b458d2e235b3193d94903e28196)], [uint256(0x1023e3c2d33e44c96de20df02855ca894b08337511144a594355fe05e5a8c29d), uint256(0x2898f2e5a0d423ab6cae91826c019099c4bd920194a28c3f6adae23fe4797506)]);
        vk.gamma = Pairing.G2Point([uint256(0x22addc6983055608e4745a06078ab82e1100451f68bb2be5554c0fe51fce7733), uint256(0x1729b34a8b95d5e79ce180da08aadbc6a92bb1c39e9e559e7372083b1784f5a6)], [uint256(0x0c345654374455d60866503521a5dd7fab649a40cb0f274b2b963e9f16becb6f), uint256(0x2c752840a318b09f92109458d5603f0e1d6a83a187b5e9fc855e7e2acee6b762)]);
        vk.delta = Pairing.G2Point([uint256(0x1a9f1ab9b6c80d719de495f985e12ddebf6252506d83f105e998d7a82df08437), uint256(0x0df36f67e912583f3f0dfb83a40e5c7df22405c2f2efed35f3e8ed9ad68f72d7)], [uint256(0x1430187a71c1300fb61ac7cb5dc2b257fc6c84b7f0f0319b4c6029a4f8f4378b), uint256(0x23bd85792392671f4abbd6f78f7eaa7b5205f44416d26563b664da620b8cb6d2)]);
        vk.gamma_abc = new Pairing.G1Point[](15);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x04334131988415e67776f3cf052adef63981b1acb124c19153dc6bbb095dcdc1), uint256(0x151beb738112d9bcd7e72189d2be4d97c5ed1b46204a2fd7e4de44a9f308cc2b));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x152b405183c193b10452712c25705ecfa2fac12cd4198749ea4c929a4cfe37d4), uint256(0x196ac3266dc0fa6d34e230c15e460cb418a8c0d8a774698a56d0652bead855f9));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x19c31924d622ece78d228dc1de9764c622689da5accbdbd7bfd12046fc615c55), uint256(0x2c191db45e68da7fc42a9e9041fed2176ba7c123d5735f3bc8c8eae53932a000));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x2cefeeffff9acf0f62a131cb9f38feac8ef314b70b774641081c1b748bac0b9f), uint256(0x0b6d011b103fc0963b4d3c477ecb8e6c289fae00afe9dcf88360c0bac421cf88));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x01cb40b2f42da9c5da9164a73ed7b0beaa0c21f7759867e0d11e808f044a3e07), uint256(0x1e76851b501687a58e0d646234bb3ff546586e3154aedd98ad063a5ef2d94766));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x1dc963d8409ac1076a5dadc1801d7b089fbe08dbc1a1ae2dd2fcc630b48aa410), uint256(0x1c97847c47ecb168ef63417b29e5b2ab07e3e4e4f1931a7c9269c1d85dbefcb7));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x2b5cff810771e40568f32f3c5be27a602637ccb1c1aa7fb55221f6e7fefa00be), uint256(0x1b9d4d9846d7ef96426e04e009dc901c3e195db70b9aba541b87ca31e6207b0e));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x153375dcc8b65eda3b1818f3023cc024eef53dba961b7636654620adf037a9ad), uint256(0x26c98e900de92383c0228d7484b2d7184fc5fe47db08da1a3b2baf88aab22bb6));
        vk.gamma_abc[8] = Pairing.G1Point(uint256(0x0231f14eb32736b006fd69b522202696e410c6ef8033f979a46bc12581b8b4c1), uint256(0x2c6737f653726551edee29331e53aaef34bc2e09b5068ea4ebc105e32d4e641f));
        vk.gamma_abc[9] = Pairing.G1Point(uint256(0x00f640b86fa9f52e377b25ae97708ddb53b619d3337c09bd14c48bce74eb2ed4), uint256(0x086c8104d8e8b9c16855c93e036594e9c0afe1a74f15b89e7c175e7f2670de18));
        vk.gamma_abc[10] = Pairing.G1Point(uint256(0x2074667f4a1c5919a107ee56aa0b63be5b124d66bd610c5eaccf59f6d24890bd), uint256(0x2ded36d3cbdd76bb5d591ede83df74493bd9efd31aaba78d587b5ac24b8bde43));
        vk.gamma_abc[11] = Pairing.G1Point(uint256(0x1d1d90fbc4861352377d27edde3d7fd5c30f03bdf3121e13370d57097a946797), uint256(0x3028e9ef50ca2f481f6308f9fcb89a7db2db0ff8d225519f9b6d16386c6abca5));
        vk.gamma_abc[12] = Pairing.G1Point(uint256(0x264ea4238dba4bf2207edd5bd8c19f20385f4874a376f5226feb5a3b79177908), uint256(0x1541dc0a65792c7068c021a49029aa2fced7bfbc7a469bcb38fb1e2de5f4976f));
        vk.gamma_abc[13] = Pairing.G1Point(uint256(0x0394e12ffb046726c716938309aaa64ad025564c44b27562078dbb8b2add5c76), uint256(0x0014ff446e4004051cdc82a7b21dc1c2e279c8edb66f46cf8b1b88d3e8e71458));
        vk.gamma_abc[14] = Pairing.G1Point(uint256(0x25693768bc4068c90a44d6dbcdc1aada67c44949610936b2f086efc22a630e62), uint256(0x2271888b467d9b5b6d8d14f8c7f07a1bf10886910c623ffd5c951054c40aa754));
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
            uint[14] memory input
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
