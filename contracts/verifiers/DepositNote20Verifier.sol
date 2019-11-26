pragma solidity ^0.5.2;
import "./VerifierBase.sol";
// This file is LGPL3 Licensed
contract DepositNote20Verifier is VerifierBase {

    function depositVerifyingKey_20() pure internal returns (VerifyingKey memory vk) {
        vk.a = Pairing.G1Point(uint256(0x0e60d2a3c95f0d2055614f60069b09e590b96da61a4a91922f1955da2e637809), uint256(0x231ba48371df47e38cc37837326267a06b239ad5272ddd73fb0c65007497f481));
        vk.b = Pairing.G2Point([uint256(0x07667dfe8bd97534f3268d91e33c648e3e95e9e51ca16a32564ae19777d21ca9), uint256(0x16bc482927c833609be9f7c70ec855189a17c17a5b9054ec6288279c86369da3)], [uint256(0x10eb5f09b460d6532fee9d44f7a1032b19f8541e07bf3e050a61b1b36d0dbd36), uint256(0x18e1f12409f427fee2f7675165c67d44ddc51b1a473f4b111b50f82abd572e69)]);
        vk.gamma = Pairing.G2Point([uint256(0x0f6adeef83bed773a9bbfa20a2175f9dea40120eadaed3e083317f7eb747aa4c), uint256(0x062a382c63f496acb22b789ac05c03fab02f5d83fc16a80d28a55dd31cbf9566)], [uint256(0x070e685ac7789e3d5943ed0c9201e3f2f3a4e5e379e178946143fdf31a176725), uint256(0x29702431d2c5ee0f30bf0c6c705c0fb96f7f0b4fdf86b1bf6597c4bb31531c94)]);
        vk.delta = Pairing.G2Point([uint256(0x2fb2aa96a698b75879adb2c0cfd90b5a03ce009e862db2bb98fc42195f4c40f1), uint256(0x10d6906bfb670324a346735110fad521bb9c33cd790b58ffc2b83c732a9a13ad)], [uint256(0x24fb06200b940fe443aca208302f6fc7ed5f18483f9cfdf45c6ce6411bb30c66), uint256(0x2f68ebd10fa66a9241785ecaa0b1260ad65380494262de643099e16945d745b4)]);
        vk.gamma_abc = new Pairing.G1Point[](92);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x13dc51186e743ae509bf60c079899cbe5c3342644469357659962f2032a16c58), uint256(0x211d457ed7b89c10c700ca497a870c50e93db99fa79d5291b41c1b4acabd32b6));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x2c9dbfcf0506ce8155bb4e1cab699bd58cba3ae3c5367e471ab71adfd005ac39), uint256(0x29c59c77bcaa8d22c6544b402894353a71fac911fb55616dc271d9e383ee9f19));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x081fd228cdd52d8a31e9a30f8109ceed6335d0b2248e87f9fe73ddf563fcfeef), uint256(0x1ceef75a18b3aec368ab12a2936506f045c9aad1d06c9fc0cfb29adf973b5e05));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x20a34bc1d03c3d37f8742c5b12b61fe3149c2cd6c8f7a05c72350d415cb50c12), uint256(0x0a23f9005c9f93ba8264806d8530730c312c5d3fb972de89046907bbbe8433b1));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x10018d6d5eb33f0f7fe97faaf2f25418543c3b4eafa5bb783bac777cbb4fe21a), uint256(0x1583366167274a05bdf0416c8ac1229d0b701a54e0b4ac7c93efd94a82b0aa14));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x022685fc59c52736fee89adc1a887a5a80ba9a0e13bbb0376d44ae63315e1923), uint256(0x262a638bd731e133e518c202c4993c93875d2e0ffc912127cc74bf07362c1eda));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x1d5d9932d52e0bbd997e96a39dd484d3b44ecbaf2c1be58b744bd036a36f140f), uint256(0x07c626b9a19c11ab3de9dd39b0983e1ff604c4b7cb8480bda5b612b499552068));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x19a6c1562af21ae8180527ac54975a35d20ae6d2df000f28e9cd34698f8c66f2), uint256(0x2e8b17d6e8876c71db9c93598e3103190cbe1e118394b8d5b0336ed3a1fc4740));
        vk.gamma_abc[8] = Pairing.G1Point(uint256(0x0c7d6f7f4b709d7ff4e5f69d9c473a05920122eb8f7bd8c4cd14c40732cdc62f), uint256(0x0f8a18508a3cbf387e5742f5a8e01ab3593933079e7cf3c3b1d8f2093474c85f));
        vk.gamma_abc[9] = Pairing.G1Point(uint256(0x23ed93003e63076f49fba9b55b813c79ff47dcc89efb61af1c7bd4a0825219bc), uint256(0x063903a45e183dc4ccb8ff4d229fa8cc8a2305fab3d1d4161c3c96c8402304b4));
        vk.gamma_abc[10] = Pairing.G1Point(uint256(0x0389b0683f5863aa568fbff2a4fe2bf280644a5cc92986bc2efed283d08cb2b9), uint256(0x23ef042ba53f3c9a7ef7c3776e281a9ff994b641d7c7302e98298db0027fe066));
        vk.gamma_abc[11] = Pairing.G1Point(uint256(0x0956ee0f24a4d7daa0fc66738c748edfff8ea6746a7e3d429c1add745c238f61), uint256(0x042970558ff9d47ed9d8da81e0d181d177dc1fdca0c9294ab8414f56abbb9947));
        vk.gamma_abc[12] = Pairing.G1Point(uint256(0x2168e8451b76d2c8ee81ecdcc7b38766fb9fe29e8297e364b8c5186d6e92b2a5), uint256(0x1104304d75dd4d22e45f3c4031c1c8d4b4c0065fba80606b24b091bf8f268e52));
        vk.gamma_abc[13] = Pairing.G1Point(uint256(0x1d3a0f5a92c9bdd43a5cbffa9b614203788362714fb4d1bb3b414df0352ffa4a), uint256(0x3023f456e7451c17da9159a745fecfc6dc518669323189209104f2d1955b0819));
        vk.gamma_abc[14] = Pairing.G1Point(uint256(0x1f1fc9807f16cb7223183da0de676bfaf860849e983ca97d958947edcae72c1c), uint256(0x1d27f646cf72637100055ada18dd6826dc27e481958fe5560146a36d3534e95d));
        vk.gamma_abc[15] = Pairing.G1Point(uint256(0x23dc7e0ff0d99a3618cade318423dbad0739f00257942cf0d9ac51d7c0e19d7a), uint256(0x20ca3ae691b2bd5c3882e56c78381dfe2ffa81a3f9b1735ba76bc14d07b0582e));
        vk.gamma_abc[16] = Pairing.G1Point(uint256(0x12f808d1de2bd32a0346459f9a83eb8d138422648ed7c86545ccc33764924f6d), uint256(0x164dac70b17bec84f4e39768710a71bd8fdb36b753f73db3aa618d82305ba69d));
        vk.gamma_abc[17] = Pairing.G1Point(uint256(0x199981525f8d7872af7887123b6a5822559812c849bf1ee0c0fa63bab53f3bfa), uint256(0x1ba1ccf474f6f66e67ecdb1ed38be780c11aa42fa884c36611c408facc347ab7));
        vk.gamma_abc[18] = Pairing.G1Point(uint256(0x08161220b69146e7fe1490db7bcdcdaec4db191bc2b59dd11f3a62604ee4fd13), uint256(0x1ce98052a1490ad94c44772056f3aa71c5cb5bcf6639eecc9115e2945cb87a76));
        vk.gamma_abc[19] = Pairing.G1Point(uint256(0x1c40ea2a18b25f9a3e0bb88c88bbca5cbb28a8e17d24770e04e3bf476ab78473), uint256(0x0960c93776f44910a8811852b2a00aff952912a48a171c40344e9af58909fe9f));
        vk.gamma_abc[20] = Pairing.G1Point(uint256(0x0eb08ab0f7ea9fed8ce42d15e40acaa6f000323d46493b257c69a4f86caf827f), uint256(0x243f9a63ebf0233d66678bd3803f01fe376f0cb29f14a457b1617347d96c70f3));
        vk.gamma_abc[21] = Pairing.G1Point(uint256(0x2ffdc30f8bbf945296aac4c261fb200d6155471e9e83bf6541094b0f97d83858), uint256(0x0771ca75058d3194eb2219116f72ee39b86887fc5c0f31f111ca3f2f6c4169ed));
        vk.gamma_abc[22] = Pairing.G1Point(uint256(0x24418111b55e1cda552fcdf4b3512dda48f6d82b95173e2580e64086bff95347), uint256(0x1b5bca3cb2f1264c12272037619bb5dda1ee1864261debc23819f47a98f1f25d));
        vk.gamma_abc[23] = Pairing.G1Point(uint256(0x27cc3a046c7f9169e003685ba4de0c93810fee7b81a3aaa0873363dc57a4176c), uint256(0x0a3c4f389918ad6c12408485c336888260226a494750b311f0bc410ebc74032d));
        vk.gamma_abc[24] = Pairing.G1Point(uint256(0x084d1e9f9c2f0099eaac324b097e95c72bb1591a7a2a042ba7ec76bde0a26d41), uint256(0x0f73d308f3efb21e18dfa6c83e4e471c42cf7350b94d2d5144b409480580dd41));
        vk.gamma_abc[25] = Pairing.G1Point(uint256(0x283352bfa8150c9ad76adbb46726ea6c8aa131c00e1b96dd7fdd388bbbc8f6b3), uint256(0x2fe53c1f234a2c7eac45d51fcbe11b0d12052c2591f208eadee71c0ec2c85e67));
        vk.gamma_abc[26] = Pairing.G1Point(uint256(0x137385a31453c8a1f29c72afc69ee5d863bfe752f661889ae78e2afbe9df045a), uint256(0x18965006eb7698b75168613c16d29982877be10cf254d4f86c9039a9ce0966dd));
        vk.gamma_abc[27] = Pairing.G1Point(uint256(0x0a717781a5c068b8de5ba27d098ca5c34e2751d2d0f5ac5ee99c85c30fdbb6a2), uint256(0x226a2de7fcfadc8c3caa4ed9bdd987420fca3535e75d10ea3fc3962ddfd7edf1));
        vk.gamma_abc[28] = Pairing.G1Point(uint256(0x154bfdd6982a3e10e973b2d8d1cbdf13940358a7ec8a68ca80a04ac3e1acaa0f), uint256(0x23f97b91beb7980771be922972721c8e700cd1ed9d506898fad1e530146f8d8f));
        vk.gamma_abc[29] = Pairing.G1Point(uint256(0x16e50c2e46187e8a5dc868e4d29a037fe6cf4b9e001ad135dd9ec4a70f179ec8), uint256(0x134b2ae7c3f2f7e6625fe0e7c847b2496ecfb5f2fb06e2277e0961207d2f333e));
        vk.gamma_abc[30] = Pairing.G1Point(uint256(0x1f955353615d49933b9fe682fb8b2616e2bb51e10b03439ce4229e990e8e28cb), uint256(0x132388d40305802baea06f2bb2b8a12b72d028698444ed2f5dd98201b9f1e285));
        vk.gamma_abc[31] = Pairing.G1Point(uint256(0x25b71abb996d79ee683bdda0e7caa0257dd3e3b498f85fba4b3569f866c7e3f1), uint256(0x17aa4d5609ea06d658c35d93cd578679f97852905b5cfc122ef6ecc8e368dade));
        vk.gamma_abc[32] = Pairing.G1Point(uint256(0x0624f0b8842300a37adb889b01df2013ac7c8106ac6d9979b51f43a38416469c), uint256(0x163bd1dc17574400b1d4fd489c7e0270df1880f97d4b9e7c00c3692c1b4672c9));
        vk.gamma_abc[33] = Pairing.G1Point(uint256(0x0781fb7b9a6993fc869cb7937690499c306500a52f92f93c32aaa7c0522c4c6d), uint256(0x1cb33940a6207745d7d7a9abbbca8b779749cdc7d168a587ff305b483b73a883));
        vk.gamma_abc[34] = Pairing.G1Point(uint256(0x049c6b392fa97d6755522e5c8dd8e56031d66d17b525909f1c18dcf3b8954a87), uint256(0x2cf66da033524ca41f14a24032ffc599553c875a694cbc0a2f4c46406ce98487));
        vk.gamma_abc[35] = Pairing.G1Point(uint256(0x19859aa1d9f42ae1e9bca00bbff0d5c87b665a398c446ec85c60be09c3e7e039), uint256(0x0b4d6521e54aed534154b52181088b938950e9a74cb7234cec6ac897ddb74b3d));
        vk.gamma_abc[36] = Pairing.G1Point(uint256(0x1263fcae30dd610d24c61550511743a7046a15367122848be184dd2e034db157), uint256(0x0b7b9539599485246e36b98953ad430341f2aec692c63b58afeb6d183ed57d2e));
        vk.gamma_abc[37] = Pairing.G1Point(uint256(0x158c1d655aae7b65a7c3aadb2635d9c7c551893be55299ace28c117c5fe9da34), uint256(0x0409af1e398ef6e41e257ad598a2503e91c1a27b2085ef097b82050179433370));
        vk.gamma_abc[38] = Pairing.G1Point(uint256(0x24a56e60a8247b5e0db796201f2ec8b224b63eb250ffdec33cc4c55bbe7ab2ff), uint256(0x2a9079d94627e49c122310f2f05fb89422b98064d83ab2c4d9ac016fd0edd668));
        vk.gamma_abc[39] = Pairing.G1Point(uint256(0x125f240927d5da3e35753323108672e4d8eb9a035211f13341a0243163e8ab35), uint256(0x2effaa2245ce2d48ef0ca00f0581fe22ae395ed01acafe55382334a8dcf1842e));
        vk.gamma_abc[40] = Pairing.G1Point(uint256(0x023508296a205f04740bb478b3b2ab5d2107b9d472600bd3b562ad1b1c21f074), uint256(0x0d98a1c57b26491a338f8be795f6ae7ce35c8d6b09dcf3f26860d94868920ed7));
        vk.gamma_abc[41] = Pairing.G1Point(uint256(0x0e7f3c96051ea3f73218363fdf97d37f76270b4453a7933d2a2efe96747d1073), uint256(0x1aaa4c3acf548d26667356a969be53ed5590b49a6533867e1b377b07834ee2a3));
        vk.gamma_abc[42] = Pairing.G1Point(uint256(0x064da669fa11b34ddb5359967af84dd7fbae1f42d06359adc6ed38440f516a30), uint256(0x128c4b1bbd43181d77a21bc23bc0b35782980378d7f4004a7cf8a1d24f1b650c));
        vk.gamma_abc[43] = Pairing.G1Point(uint256(0x2155f049251a6fa50611d7a086c445ebe104b611149f6d4ef0308ac38359959e), uint256(0x092c6a0914e1789c7c1cf34bc8ff540ca5b9e5ebb28b03d00b9160f680bf579c));
        vk.gamma_abc[44] = Pairing.G1Point(uint256(0x07b9480fb9393852ccf3ad9cf5ccad07f925e2464c86391afbaf740ec91c22aa), uint256(0x1c3164c6de4f9d5586d7ff458c2160d524bc0237f1bd6aaeb08767eb15cdb713));
        vk.gamma_abc[45] = Pairing.G1Point(uint256(0x1720c34618ea6ddd0237bb231b49dcc70559cf0348e35c50e2ea90d4c109bd5d), uint256(0x17923294b85004bb1c3dbd51acb71d2330a4f220f6786e3a9576cbadc5ad2484));
        vk.gamma_abc[46] = Pairing.G1Point(uint256(0x04fe17190ac6c80e61a5da4f89f060fd202414f2462d8456234ea09b5b681fd1), uint256(0x15e459285dc4a6a16e7627c43cfc4957e65384642169e24d96e895c13b674c09));
        vk.gamma_abc[47] = Pairing.G1Point(uint256(0x2268ac92f5294f299ba483791472b328ba4e57ba655554f1cece1ee1e661e370), uint256(0x08f54e3a00287256ff1113d116a9f1a0d111ad6ce0a8ed63a4b12f6cc1d9fd18));
        vk.gamma_abc[48] = Pairing.G1Point(uint256(0x0e1344ebc22b8f5133c7088ed425325067c15e1ae8ddda446baa8f86529fae05), uint256(0x0661b6011a4be3b1c82e3d17659a7bb28cd8e7015fa5aa84f89ce24f7e7a79c4));
        vk.gamma_abc[49] = Pairing.G1Point(uint256(0x220db0ffd6ba93b0e1e25a03cb6049e4b642024aaf2ecd8e254d4be6d673e473), uint256(0x210467dbbe6886de2b7c4e50e3500845ca7edacdc6050059791f30acec3d60f7));
        vk.gamma_abc[50] = Pairing.G1Point(uint256(0x0fc8bc869f34195eae65bb9b90a7ea163843efd4b059b6dd1a1c846d9ebd9de1), uint256(0x06da4cb1a5937946ba31b57ac6d0a17a28d65dc38b777ebdaa5f8ff051ef59bc));
        vk.gamma_abc[51] = Pairing.G1Point(uint256(0x084dc5525fa612c3b0335a2b6c04f46f37b37c3817c7ecdd963ffe92fec30bb6), uint256(0x0d9a9db9c8ee025859eb44453236a448ea5c75b270f17d577ba17083100b856d));
        vk.gamma_abc[52] = Pairing.G1Point(uint256(0x0a793c8233960cc14480d48ddd2ae7e0ad864a25b11738541b240cf94e6c195e), uint256(0x02438118604fa8dd416fa5f3e92bb3f61860715681c8200376ca4120ccc81aa1));
        vk.gamma_abc[53] = Pairing.G1Point(uint256(0x106e6ddfe3bb8b20ad0802dbb62d045297e49b185fee7c1ee666991e666b71c6), uint256(0x2e532a442463f3d0705b9e5f95a4f5eed984abcbc126cfbfbfab3b7a68f86805));
        vk.gamma_abc[54] = Pairing.G1Point(uint256(0x283f7d94064154b497841cb93088c895091b8209ad1c740397c217a1e0b9a136), uint256(0x123c3426d95ae11651877bb606198273e457b946fe6c31a2cbac902b61c7a8f9));
        vk.gamma_abc[55] = Pairing.G1Point(uint256(0x1c74918c31550ef290a01f788c44143506ab4c2e3e5f56d23d7f2ddfef3b76f0), uint256(0x092a404a504f8c4c3c8032e9a2534086ccbb301161128c8937a73f464e0a49f8));
        vk.gamma_abc[56] = Pairing.G1Point(uint256(0x2477e09901cc1d0df703e1605b08d8996bdc2dfa87041baffc2fa5887739761c), uint256(0x2c31809bd78b4835b700c0253319dd067cce176a9de260811aa566dce6150112));
        vk.gamma_abc[57] = Pairing.G1Point(uint256(0x23e88a7e915e7d5bab08a8c0de0b4c49a7e2ee71ff38b72fd867fed258b6aa22), uint256(0x21b9268e59403e05bf72b26246506fdb38a7129684c13e22bd6efb584f6a22c0));
        vk.gamma_abc[58] = Pairing.G1Point(uint256(0x0be2f3c5d00207cba037b3237714f0bde0c6f75116fe72a6a87681387d4fc6d6), uint256(0x29bbc75eaf5677d397a326c9d87b08a68055fe8b4260be6f85d914f2a0646b1c));
        vk.gamma_abc[59] = Pairing.G1Point(uint256(0x262e210aef2fa2ffe58ebad7f049376de562e2d75761020af59a816b1a155f12), uint256(0x07e9a0a9397cc27d88c4d3003a56c0c9f5e1e5582177b8f89f7b64b812fd4238));
        vk.gamma_abc[60] = Pairing.G1Point(uint256(0x20c6eb8319cf1be4e4ff256756b1f83026c47fc6076b6ea413b20ecfabe4dd3f), uint256(0x0771aec5b5bab7d99f106219064c0386d2abdc87184309ea7eee6855148df2f8));
        vk.gamma_abc[61] = Pairing.G1Point(uint256(0x1b0154a5916b454b23650a5180b255d56bdb20f65c64542139321cd98c757fbd), uint256(0x0e2cfb9a4d4aa6043448f214b285c81dd6f13d5fc7e6d3d8b7c1814f9ddf3815));
        vk.gamma_abc[62] = Pairing.G1Point(uint256(0x16b8a10a3b388e92a352298f582fb3333c6ecea52e8982bcc7c2d33d97f9f68c), uint256(0x0a3f90f8177b403cd64f34de30fab4899cff347ab57d186b62b84e925d41b991));
        vk.gamma_abc[63] = Pairing.G1Point(uint256(0x070bfbeb41fdc62254c5fff65c604503e05ef7765541ba0bcf40b561896e658a), uint256(0x00235b338e6c55cab275c5a1b5b4beb30ac3456ff33e34b0d85ae15a5c40b751));
        vk.gamma_abc[64] = Pairing.G1Point(uint256(0x09317966adf3491962187c7b852f3991bc4948241fcb38365d1b522c3bee2280), uint256(0x17f1a802da7e76aeee1035eff41d9df1ed0612a6556b84aa91983d2464665fd7));
        vk.gamma_abc[65] = Pairing.G1Point(uint256(0x2d4613bdd769c1a3cc25bf8238c46b1a5374939ef33f5f171df3b71db43504ba), uint256(0x2384ccc22b3cca738b1e7868875cc2cf5b2889844ecc853fd079a9cc2984855e));
        vk.gamma_abc[66] = Pairing.G1Point(uint256(0x1075d47c3b3dc6c6ae6a2725acd9418840340eb2f70392084164d599eb0020e0), uint256(0x145f4df42137796a83b68aaee26d5a28bc58ecef990acd7725e9828c887f8e3f));
        vk.gamma_abc[67] = Pairing.G1Point(uint256(0x00700146b18972a7505f5b45e4055a14b90d5518c5252ed72dcc5faabacfb361), uint256(0x253838c48727918578acc183164bca7c65f4d159fb5be5ccf37fe689fe77c695));
        vk.gamma_abc[68] = Pairing.G1Point(uint256(0x2f8340f1653bc5652f520b4b46f633bdf901b844ac00b11c4e85af39fa0939ba), uint256(0x25a589f3b5af0cacead36ebad7135b663147a2794abbcdcfb0131ebc8b834956));
        vk.gamma_abc[69] = Pairing.G1Point(uint256(0x1b826e098fabd5bea0bca63164c8615826c655b72dfb56a1906eef331455f5ad), uint256(0x19583d6ad19d6567564764294f300fd8ea4e555d9bdd736ce5928e63ec950dea));
        vk.gamma_abc[70] = Pairing.G1Point(uint256(0x2699aed7864e642d0918ecca9926d7ec3f38e1422c8257d17bdd64bbce881493), uint256(0x13d0a83ffea95ee92a718a0002fc7a40b5b51929057c6951ee9eb42e0333ecbd));
        vk.gamma_abc[71] = Pairing.G1Point(uint256(0x1b3b363cf2fce193b91976e97a0a3a1b711f46f880cf1fcb7b276f5c936bd8fa), uint256(0x064475e04001431b96ed12947c157d46aff52fc6f5f1343d47fb393fe098aff5));
        vk.gamma_abc[72] = Pairing.G1Point(uint256(0x0058fbf347fe958ef2b3bba55206a00000db6045d98e96a5dddb093276466f78), uint256(0x2d5e4b765afaf477268a94920b77b6d611a475ff733df76f478bde4ccd81a2db));
        vk.gamma_abc[73] = Pairing.G1Point(uint256(0x23074efacd53f6bed7f3f624ca2406cbbb20fec1f69987af31772348d1bee2c0), uint256(0x24ea6c011e44cbd21747be36e194ff37328e3552fda150b58f39b3f7c245976a));
        vk.gamma_abc[74] = Pairing.G1Point(uint256(0x016a2ecefe715fe5200bb3986d7e16b1f036b30325b4fd60299e8330eaa0fea9), uint256(0x14131c063a600ed921bd0ab5b24439661cbd609b734dc789c811f199e0b70700));
        vk.gamma_abc[75] = Pairing.G1Point(uint256(0x1832027e9e7d0000444bbe086537a12887c5bbdabd0f63191ff665952aa7506a), uint256(0x214275195597b933e3963eb0654a3b71ad0c701d7c92117bec0702fd0cb52883));
        vk.gamma_abc[76] = Pairing.G1Point(uint256(0x02b1c96004257023440733b8e1dc2299795655c7e57a38bbdb8410487b2f594a), uint256(0x18473b1d762179cabf0d4a8fde9451dd87125743a7ad0477b233f0785aa9bd74));
        vk.gamma_abc[77] = Pairing.G1Point(uint256(0x15b93b0406ef886f91592b9bfcb391f911f152fdd98c52c8cbf1756104822b44), uint256(0x208973b56f790aa13cf6a58ed69570211124bd066ba5811e48fe27ea57f1cd35));
        vk.gamma_abc[78] = Pairing.G1Point(uint256(0x15aeffcb91d155008e99931cd5c867b3038a3defb5d3669ef762c3f7e084c278), uint256(0x0ed8f33f54d678929d31c551bc6bafecd9184a7544b58d7ecd9f36b9d63f77aa));
        vk.gamma_abc[79] = Pairing.G1Point(uint256(0x18eafa8a66d76f2028eb1d34254149a4a798574da1f926921303d560b0225c10), uint256(0x0c8c4892a804b8140224d0dd67490efdfbac9bd88cd6803f43d3ab1fb7147557));
        vk.gamma_abc[80] = Pairing.G1Point(uint256(0x03406975e47f3547800c87d6487780f8757d7a2dc2ad0bdf699fe40e114599a4), uint256(0x1a6331a12b5054e37171eb168913c805505c88326dcb3fb46308db8c01c96c9c));
        vk.gamma_abc[81] = Pairing.G1Point(uint256(0x174f1e171cb2f9db551767d96deb3add6a449ad1bd4de5e2d0b4957036723c1d), uint256(0x142467d43c74e653cf068507a1be1d24e02e793617916ba9b9d3368cd7aa57a8));
        vk.gamma_abc[82] = Pairing.G1Point(uint256(0x052017ac6480e666bf52256bd1c4559502f5c165e18e91155297b0b34e42034e), uint256(0x17e886f4b1f26179f13265669352a998b3ad7194988c777ba3a4dcf141daa636));
        vk.gamma_abc[83] = Pairing.G1Point(uint256(0x18fe46e629ad3ec9a6a263fbda690c9d77ada581f1cd7a29acb7e32414b6660d), uint256(0x2abfe0d4a8e8256009c9ae224cb6edb571c514b2d59ee963330489062db96dcb));
        vk.gamma_abc[84] = Pairing.G1Point(uint256(0x0ea298770dd617e08b894faac3febef1dce4004d31d9e9d22efd8fd9497db2aa), uint256(0x17a4ddc17ce0a3f28c722ccbc47b81477cfd7507c33f78d63495ea4c46996d13));
        vk.gamma_abc[85] = Pairing.G1Point(uint256(0x14ae398fb5ff8d8981e01a7de9d39c65ad92d8ce21eb69a9dfa1d4d6ae83ad99), uint256(0x07a1b30063af374150313fe71931e5ee25eda12e247001fab6a4999a9ce1d88c));
        vk.gamma_abc[86] = Pairing.G1Point(uint256(0x015510579b48e37c2339d2d5bf36a11791ccb956ba70236212c17cb0dc12287f), uint256(0x0943c9d916b65b0ea115c5d5d63778f2207f7f1465c143f3131cf78cf19e0421));
        vk.gamma_abc[87] = Pairing.G1Point(uint256(0x2cf671ccedea17c44a9dc64d505e6680d87644fd9b58b997354be30c3aedf6da), uint256(0x08fea034e41f79f2feb3b28982fa0782a96fc358e5cf6d7d84e81f7ba777809a));
        vk.gamma_abc[88] = Pairing.G1Point(uint256(0x15704549ac58a2983dab51bda09d3f6b5bea30c0b530062728a016e3414dfe5a), uint256(0x069b0e200e64c17da7874d3dc9e2d3c3117318a778c5ddcfb02f5af6f5df189f));
        vk.gamma_abc[89] = Pairing.G1Point(uint256(0x25854b567aad8672efce74b69676c845ffca7fe69d4d7de436fc1ed917cedcef), uint256(0x0b3a20baffee6c2a0a5ed9d799455b3d79193cce82822c179adc217ad910b506));
        vk.gamma_abc[90] = Pairing.G1Point(uint256(0x28eace318e6c18c7faeb01c49d8cb7ca9bf134da25336b74617f3b527b800be0), uint256(0x23adfa94f4115ceb6cafa599b16d8b8666683c84045b91ead5a644df70eb8c6a));
        vk.gamma_abc[91] = Pairing.G1Point(uint256(0x2b0b51d89f62560b4307f3ce89eff3cb2835f6acdcbd2d4389ca008648512697), uint256(0x2aac5cec10e7da5157bae8bc9bd0d1a09cb393fb0345eb4f05e77e679f0f6256));
    }
    function depositVerify_20(uint[] memory input, Proof memory proof) internal returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = depositVerifyingKey_20();
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
    event DepositVerified_20(string s);
    function depositVerifyTx(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[91] memory input
        ) public returns (bool r) {
        Proof memory proof;
        proof.a = Pairing.G1Point(a[0], a[1]);
        proof.b = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.c = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (depositVerify_20(inputValues, proof) == 0) {
            emit DepositVerified_20("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
