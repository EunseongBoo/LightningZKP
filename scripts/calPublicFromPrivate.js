const util = require('ethereumjs-util')

//privateKey: '0x44c0c9e3532f9691c9a7ece9785061c57aed5c5bcc2d5c15b544e20ccaf92033'
//web3.eth.accounts.create()
function cal(privateKey){
 pub = util.privateToPublic(privateKey);
 console.log("private key: " + privateKey + "\npublic key: " + pub.toString("hex"))
 return pub
}

console.log("\n sender \n");
cal('0xf8f8a2f43c8376ccb0871305060d7b27b0554d2cc72bccf41b2705608452f315');
//'6e145ccef1033dea239875dd00dfb4fee6e3348b84985c92f103444683bae07b83b5c38e5e2b0c8529d7fa3f64d46daa1ece2d9ac14cab9477d042c84c32ccd0', // pk
//'f8f8a2f43c8376ccb0871305060d7b27b0554d2cc72bccf41b2705608452f315', // sk

console.log("\n MPK \n");
cal('0x01dcf0f9bc5eecb87b4d16022a5e563922b5b39c34f50a308de4a7aa26e33349');
console.log("\n receiver \n");
cal('0x44c0c9e3532f9691c9a7ece9785061c57aed5c5bcc2d5c15b544e20ccaf92033');
console.log("\n test \n");
cal('0x7abcea3f35fa4229874e55bb29a0da13700de365e2b6e4d41edbb718519089c')
