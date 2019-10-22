pragma solidity ^0.5.2;
import "./VerifierBase.sol";
// This file is LGPL3 Licensed
contract DepositNote10Verifier is VerifierBase {

    function depositVerifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x1ed79da9946f11b56739eebd69715bbd2e25ff5729f22a5c6a66a05da13a191a), uint256(0x0f3d7d3562bfae7b9b182baa31378442818c53518f236af47bea7d226309b95a));
        vk.b = Pairing.G2Point([uint256(0x199eaea01c7a80c7746193d62144b95f3fb5c33724eb3e49e1b2f8ba73a486b3), uint256(0x0b4d84af9184c3252ca02f5f971b90fe93900efdf808b03ed696e727fea82fbf)], [uint256(0x21e933dc2a5e984ca69f8452383ea2f06d8f9ff9eab57b68340238777dc0ab54), uint256(0x2d68b9a794081f851ab546e7b12d40425ecbd004c24b4f97901ec13d335cb37b)]);
        vk.gamma = Pairing.G2Point([uint256(0x14b3178b6f48c2d5ed825dd5fca853fec5155deda001ca7520ba1cb315014db8), uint256(0x2840fb55a8f2d80c5c16c4258fbbd7cf5526a80d264c1fa8ad778ef8c65954a0)], [uint256(0x18b08b3fa2e6be9f2da59155492c6ec8a6bb7fd35e2c3498fa5d244a8809042c), uint256(0x2d7ca6923359022ceabc8cc34f9191594363413b9c29269d3d95698c653f637a)]);
        vk.delta = Pairing.G2Point([uint256(0x1d73a8b89eef993a52db1149768a8cb709ec7b0dbcb6f2443ccc61a4f4379033), uint256(0x2b5e7cd3b68c1ea0facb6b06f7067792c792e7055ecbc3dd0fa64eab7a32c8b0)], [uint256(0x0f587facfad3240307501fb092c8d6f6616058fd8c2c37b77606eeedc74143a8), uint256(0x2db9df5074db5299c6e965a55185ad315f1334d54a14c39da486151a22f4598a)]);
        vk.gamma_abc = new Pairing.G1Point[](52);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x020dd35a52a98c3eb52efabd69019ae7e99b208f6d03030bc5adfbd25d928c45), uint256(0x0d19803fd262b3000d91c66a28264b6d72029c3bcd237628cbc0afb24e13105f));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x05bbbffcc3974d50caa9cdf5a5aaa56fec577c5e1d5af2d20718328082da8e56), uint256(0x03fdd236a681bef3ff224e2475e29df541ce50e2fb2e0339176967533a58c066));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x2be0f870b4d588934105eb474bcc8cdc612789298f6e46a5287863ff96593f23), uint256(0x25eaeea668322d932feaee991a7de2dea0edef185431a8af87f7fad0c072e806));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x28457c0350cc19feb66404d4d411d1ce63158d95cdbd7b21aa63cfae7ecd40c5), uint256(0x2abd1c98616800ca0b5f96e2eed30bc889fc1fd73258a4882194f8640ee48b9d));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x0d137ce8d9a2b5c26af81f977a1cf7a1d4db909b3a71df203ad7c5f66faef4c6), uint256(0x00fa2240a55a6c68d8aaadad1ab265d44333a908b7f41ffca29e08e425d7bc94));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x22e9b4189485d955ca8340f6efc46242d431bb4f3d1b79032dc9194c2ecb8890), uint256(0x1c241e8037b9fbc4852de813a33c99aec7dd3f2e9e83775a17e9c4c634ecb815));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x1aeb0dad0d37b9e3f3a31be4d3e2811019bf28eb9a3eab1d8fa192c29ae0f0a5), uint256(0x0d9ede01e0974b2ef222fe3bb4559a357cf64283f03589c5731704179799e391));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x24290dbaec9d3dfa22cf349309f823ae6064fc57d014e7bcddbe962794c7ea94), uint256(0x2ccdb477968a52b4c640aec9d311a40954a1d19bd0dd98c8fd19c69ee61b7402));
        vk.gamma_abc[8] = Pairing.G1Point(uint256(0x1021046cd8401bbef3f49f6c267398bc5859bdb5d3764f78a83aef420d5a9890), uint256(0x03a3358b96b2a0e97839110b5f386dbb278e8f0f997f5cf9339fbd007f13d897));
        vk.gamma_abc[9] = Pairing.G1Point(uint256(0x0a06afc1af6f719dd380173d0523d91aca4070633baac3bf103062acdf520bf1), uint256(0x2e7735a1f7790aefb3e85f23c82000cf3d792bf7668b899e1f55991270bc9583));
        vk.gamma_abc[10] = Pairing.G1Point(uint256(0x0d33ee0d0e82a372861d6c96359ed7a62a7449d4bb24f62ad7acba33f896adbf), uint256(0x092729ef8405845e16e36710a9d8385dbd5a9b05be3cbc129abe585b3162766f));
        vk.gamma_abc[11] = Pairing.G1Point(uint256(0x2495200a919c6e7ccad5fca29fdb0cbf37a9498cc69c5c8e6b726a425786a758), uint256(0x0cb265e93bd3da95097dde1f38640fa829fc03f4ff9fcca06389b4ef32fcaa18));
        vk.gamma_abc[12] = Pairing.G1Point(uint256(0x1104371553254e47929fe212f65697ebd63595544666a59b9b3085c5170b3517), uint256(0x17a723f3f79ef508d17f1105f603e953dabbbc214a07ea6793aa32b2e984d5aa));
        vk.gamma_abc[13] = Pairing.G1Point(uint256(0x1acf9cc232331075e2032eb34019c6dc6b62bc64d675145aecd2c19eeebeb7c4), uint256(0x024407d354a1ea81893bcd2c14e4d7d44cc5a200177a77a1ad3dd3773d9104af));
        vk.gamma_abc[14] = Pairing.G1Point(uint256(0x13d6028d3db314a0b3b2c905e9a86dd70abdb5cf8dc41546442ab0a7e1229f94), uint256(0x105502aaffaa55bfe306d105178ac09a594e834a825928c7d55a2692c6d4e277));
        vk.gamma_abc[15] = Pairing.G1Point(uint256(0x044e002e3bdb31b8ef305f864df043a6e7a7507635f13e28cc782d597d2e7894), uint256(0x12350f8ffa515b984a4001560b3f676f45540a71f5b607ef0101a4dfcabdcaf0));
        vk.gamma_abc[16] = Pairing.G1Point(uint256(0x2236070c964542f87eb497d4454b4a6043aed7a23365519266584de32ff7df72), uint256(0x1536f1f2bdfb14997229751232b756418c56d41bb2bef7477e739f50e8fcf459));
        vk.gamma_abc[17] = Pairing.G1Point(uint256(0x27306487092491d7f81246b8c4ef88d3d9bf9a14ca0096d95aafda09085e4540), uint256(0x21893d2c6dd2e4c330fcb05d1c50291399a3297b5c8d92d0bab460fa592d1753));
        vk.gamma_abc[18] = Pairing.G1Point(uint256(0x10332d1815729c17b8f719bfae6ae97a7f48f140804ace7ca41e9e817d9c13ae), uint256(0x2990e38df6aadcf78fe374ed56a239c9ff62b04a576938190e0dae278d60939b));
        vk.gamma_abc[19] = Pairing.G1Point(uint256(0x2b47e7a80deee7fa6a5a7bdf91b0687191656c747fe873f72a139cb17571b8e9), uint256(0x0ba81e32edb7147afad29c042b34c4846feb48ccc777a25015f7dd5f68b8d456));
        vk.gamma_abc[20] = Pairing.G1Point(uint256(0x1f97d3e5796503da0aea4c1527cd13cf26b7bb9238d8c20b65506c5471ad2cae), uint256(0x02f467e0830fc04b347b2efae09f5467fee9f4e7407b6efc1882e53eb6f2fb67));
        vk.gamma_abc[21] = Pairing.G1Point(uint256(0x0c33390157ff4574f399da32262d3c56d7a5a8b1f5a48a56ffc78befcf2fa62b), uint256(0x0de06ab601e44377133cdc2c8e8a67941e4cd45a794d58138d52e6a5cfa3b062));
        vk.gamma_abc[22] = Pairing.G1Point(uint256(0x1027fa4252ab77e93224eba29b44566543285b8568aaa948f3482f827f5a4927), uint256(0x12ee01a0ff4129087a4bbf857aa3da67da0910417a1a7fbe078b9525953296f1));
        vk.gamma_abc[23] = Pairing.G1Point(uint256(0x0cdc2e427b121297717ff214a295972de2ef6d1fce9221f6660873e3fda5ed1d), uint256(0x1f7cf55de250f325d2b49e798650c69f29566557b9fa3a1647b1aa1243a53b57));
        vk.gamma_abc[24] = Pairing.G1Point(uint256(0x1d6f7e7614d58ea3e08f15cfdc9f5e8f66b45807182b9638fe2e84af1ecb0fa8), uint256(0x214e1d7b6ee8218b3806d2d18c90235d7150833d6fbfda7fd2a67e8368876fe7));
        vk.gamma_abc[25] = Pairing.G1Point(uint256(0x2378c40e775af426229fc16f5347a314c528fb71996bc9c20008a82b778551bd), uint256(0x06f036eeb061e76eb8b40344f5ef7f5d5c4967da31c450d37fe4af6d6be03c43));
        vk.gamma_abc[26] = Pairing.G1Point(uint256(0x0f9e3bddc5de53e2a35f6894dc97ef5a5a62c8b82be5dc18100d1bc8cb2fca7d), uint256(0x04f691f53d1fdeafdf490118b9f498e8ac4f5ac0c84b5d7245aee9904fe2a6bc));
        vk.gamma_abc[27] = Pairing.G1Point(uint256(0x09201e247155f191e96ee201917122609ef4b615565a7da536f0e4febfea50d1), uint256(0x057589cdce6659360e347b209ccf99b5aafb36014e0956862e20e3df7155b4b0));
        vk.gamma_abc[28] = Pairing.G1Point(uint256(0x1b108b40fb7d2422fd3aaee95a51011fee46de54e10de2a6e8f3d5902520a60c), uint256(0x071ef42a2f2fc2a5ddff78b7aa0e38af46649cbb512cbb365d3aac580fbdee0c));
        vk.gamma_abc[29] = Pairing.G1Point(uint256(0x049f2058e407de6463472a4de94448198624dd9808598cb805ab86dfa60f3b7b), uint256(0x056a0cfc235dc494dfd0d589dd3f61ac17f615090a1dcfa980362058afe53f6c));
        vk.gamma_abc[30] = Pairing.G1Point(uint256(0x2af0324978a494f6494699320fbf4d4dfa21127836bf85b3aed382c6a2732571), uint256(0x02c645bbf22a5ef46155d77dfd1a94e31d12d3aab961f4b4ad935d712d7da0cd));
        vk.gamma_abc[31] = Pairing.G1Point(uint256(0x2b50e6c9cebd2d6ab8f5dd71af661277fdca7687d6981eb26742477696fd8a1a), uint256(0x0b232bd48cc7eb5b82e23ef8ef9b6593835affcdbf47009455c5d53908d037c4));
        vk.gamma_abc[32] = Pairing.G1Point(uint256(0x2688d8f571365ddde076c15df79734305df770b3f58ece06cdbeef380a9a3f03), uint256(0x27cb630ae0c4b42e6b24ba2d2f05098a56aea08ba3a241f6649c876aa81ac050));
        vk.gamma_abc[33] = Pairing.G1Point(uint256(0x095351dcf3408b426797489497b9d4ccdd15cc56a49b232fd0c14a9fa25af05f), uint256(0x22d48f590a800ab3286d011ee2f0e58d235ba10116845550ef79f9dae19ac2ca));
        vk.gamma_abc[34] = Pairing.G1Point(uint256(0x2b3a7bd8e3799169e414de6761e340372497672f7e220a999ffe61de834d622a), uint256(0x0087d2cb4e3570bc86e027a3acd5cf75a5c3b56bd3408bba5e99a56c545a7e66));
        vk.gamma_abc[35] = Pairing.G1Point(uint256(0x16dbfb84c1db0e48e9c32b2d6bc711b9432b78574694e9e5ec1095e452558652), uint256(0x293ea489cf6abdc6a3a6c3a036567fa15d13337a8119cb50735fe0ebc0758c0a));
        vk.gamma_abc[36] = Pairing.G1Point(uint256(0x1f8ff4bb55f15eaebd891b351f75768e680efdaf63417dcfaa7477c746c780d6), uint256(0x1e3261fb3d3411f25d32d4012449224992c9ef6a879d97b43947765cb83fe22f));
        vk.gamma_abc[37] = Pairing.G1Point(uint256(0x2b3fd5b94c35676c51122e5f8f075792c20dc673ccd20bd282e389df0b842a57), uint256(0x02c1d8c0a02485db4450c7ca2330745cb981cb7043745b8443d3807eb005acad));
        vk.gamma_abc[38] = Pairing.G1Point(uint256(0x1718344fb824d587ace64b9271131c5bdf2f087eb5ad5dc6cacfe8281c76a24f), uint256(0x1d23676f73ff432ed8974c148f368d4414b9983b9644580af4b615deb8c0a8f7));
        vk.gamma_abc[39] = Pairing.G1Point(uint256(0x1a94d7719ca8c1c399cc13bb828f43fac821ba19fb65a504d23882dabcc92b32), uint256(0x2bdf62902d748469ec79e180527e8280aea92f8e13ed2df3ba963751c82debd6));
        vk.gamma_abc[40] = Pairing.G1Point(uint256(0x27a1f82f0e9e65aee0e1e5ab0be0eec1d9cb61012a0236b1982614ce68d9688c), uint256(0x1a376b601792d2b93e428854b69bb1875b434174e747d29633aafc39379076d3));
        vk.gamma_abc[41] = Pairing.G1Point(uint256(0x209eedb4423f4f16bff5148cffde466375b6e7d71367bcc28362ef3c7ffc47d5), uint256(0x08c28b7c932d2f9699ee9adc9c623765294097de430c2987b8d7de565e279aba));
        vk.gamma_abc[42] = Pairing.G1Point(uint256(0x16d383db5c33fdc5f5c3f7ea99e985a16c4e284bf7d8059e5878163e099ab037), uint256(0x07e025196e49d715f708aee207d2f524324a52e1e50aa07c63f343dfeb88fd46));
        vk.gamma_abc[43] = Pairing.G1Point(uint256(0x04dc51787bbd24d00891321cc78c4735abc3cc9c3178426435533d7b2dfb07b0), uint256(0x2ed4e9cb67904ecf3268162f0b70acd1133274feceaa17a10553af1fb3258492));
        vk.gamma_abc[44] = Pairing.G1Point(uint256(0x2b59c1408b113513f82a3eeed15946172e74e6dfdeb0b5a6275d8804f6a8c867), uint256(0x05a5ab42d20271b3e785af035508ba1ca274d9cd315827580b765b73f633e31f));
        vk.gamma_abc[45] = Pairing.G1Point(uint256(0x1b28adedaa659462b47e9a8e5966f575b711a97b371669211cb20d6c66e56181), uint256(0x144b7938bf96b1473df67e67cc6cd0a90bcfc34ee8f2e4a95cff6b1d44a4577f));
        vk.gamma_abc[46] = Pairing.G1Point(uint256(0x0663822e5aaf55ea23f8170fa9b37025379b98fd9410904ffce0ace15c40026f), uint256(0x0b8da81ad2b0074e5f1b9932d3e5c778ff0c54d60eb71cd5b7d1b16ef2b1d96e));
        vk.gamma_abc[47] = Pairing.G1Point(uint256(0x13a3913c13908e82f4f6834c32450cf920d22de586d983c12b498ddd3c7e89de), uint256(0x2679b28b571453e5b726a32388fdd67aa06511b3038ae0a28e2949a38c0fdde2));
        vk.gamma_abc[48] = Pairing.G1Point(uint256(0x1a435b9387deacbb4c7d1e6eec27451bcbdb5f7de44a6cdbbbfc4f4d2946baee), uint256(0x2393035359746610a0e5abeb8bdc1be3dfdc0c39fb83cf084cd544f38cce05c3));
        vk.gamma_abc[49] = Pairing.G1Point(uint256(0x03faf1fd4ddbd817e7c8aa51396549672bd4931898d1eb1877832dc8593eac83), uint256(0x26b0850e5fa0e7000c1b4a9f33e2ce955b97ac985e4d68793cb43b5112f93e91));
        vk.gamma_abc[50] = Pairing.G1Point(uint256(0x1f14ca2c3bb374f6a3ef621c8e59bd3dc6c4cbb000000b0de43f8035447a01fe), uint256(0x0092f7fad599d907361fcb11b044093faa60cba3dbc2daea72091777735e1ee2));
        vk.gamma_abc[51] = Pairing.G1Point(uint256(0x1b9b405f3d1ee1417be36dfb2c60cd72272f2caf67c40fc15e9569bc30edc937), uint256(0x0cbe7a4459cfc4eb517693a3d7016f1b5fe3906960fe520286219d8c98544750));
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
            uint[51] memory input
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
