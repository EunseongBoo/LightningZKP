pragma solidity ^0.5.2;
import "./VerifierBase.sol";

contract Verifier is VerifierBase {

    function spendVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x1a98ac48fe2018f84f58a2906156cedd87059554be66822c8443397426bc62a7), uint256(0x03db6d4b9d0c6621e37c5f2329a2212b4ddc29f46607e9a80d5941676e25edb7));
        vk.b = Pairing.G2Point([uint256(0x1b735ac6d76ea2df5007c6388a1d2607b799e35c30e9519da33953da9d43db6f), uint256(0x0c2a204b6cf7546ebc106470781153a8f110a61e2ab8ecd99ac77cb09b922ae1)], [uint256(0x180dd416bf72c1188ecdf599eee773f5b4e303e9efe35eb04e33f277e952f5be), uint256(0x1e35b197f94262f5fe64d0fe32af60ca51449435f6bf941df65b0d2a2942f6f7)]);
        vk.gamma = Pairing.G2Point([uint256(0x26f0cdc4bf30d13dc2cf6367e49445fc59abcba315def5e1b3729af927e6a6c5), uint256(0x065bd09ff773ec638084cf183c96d3178d3d5fd44206a7f9b6c8aa72b3dc52ac)], [uint256(0x15d1ad4691023d57db5a06ce69f081fa9e61d176e8c9a40e4a446c27b17291ae), uint256(0x2b41d1b082947fff6fd5a5df399e59d9440d1faa701e4768ad8a460fd41dbde2)]);
        vk.delta = Pairing.G2Point([uint256(0x2c4a26f13a3b4888403d5b917ca0b586a2f708955a89d25b3f5f75308d845135), uint256(0x208605906c040f4aefde123c8939f8417ef0774f59c13dd08ffdb1248f78e84c)], [uint256(0x0b7695268fa677103881aa934f7e45ac4ed626c33390477b851bb3ce6ee146dd), uint256(0x2f2fcdb0f059b6270527c5d46e3eb1af9f7463ab1ed58438c42187aa094055fc)]);
        vk.gamma_abc = new Pairing.G1Point[](8);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x0a65dc2d653564f4ea5a987bb92725e16860f9c2ed63f26663e4ea1dd2014955), uint256(0x05edc87f90a596723787e36afc4da0d32c02f77788610349b4f875da59cc45d4));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x1ac7c460c4d1553f7f303d1f384fbfb9fbfc5a14e963ed3ae75f14ae561fea83), uint256(0x16ea6aeb7d297d3e924d9802151cfa2f24b72e23c19dcf508930f5c7be2d2d0a));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x09262c81daea9019fa2a153007bc7aefda07852ba846f177e3b5259525c68cb8), uint256(0x1a1e2e4c0fc4ffb7f2423043d83236654c84a51b2240c33ac609b15bc684c587));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x1dcf0c809f804ea9e2cedb16407dd89f5af0f0b7ab211628fe51c4a9d06f3eef), uint256(0x0d39d3271f58f96eec3799622b14c869d76f421aa0c0a657d27f015fa6939a87));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x09ee43f5e8cdbe9d12fa57ae149ebde674532a40e0462f3b53b2e7a00768a280), uint256(0x13f3a99dff58fa02e9b4b636e12708f61b8c8acfa176b9589d954310b4d4305d));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x0060f976268eb38393a3c16ca02613d04deb4873399b911ba31e9d3c9f83a409), uint256(0x25610bd7ac6c62d0a575176f60f461b45852a7667c82bb0cb90654ab442e660f));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x220b9534234001a50b76a0240ff70316868b988596137240f9c8c2aa2b953d47), uint256(0x0267d3165a1bf80e633dd90bce7fd86c95913242de0b7ecb62824756cfff3c0f));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x19bf56a5653c8988330352dd2cb1d594594c872bb8932961b45390badec22751), uint256(0x13cfe41af18911a33c1bc1fe167df2aa75476b439abe3c488eff21c2d70c29e1));
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
            uint[7] memory input
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
