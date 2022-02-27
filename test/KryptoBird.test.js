const {assert} = require("chai")

/*
chaijs https://www.chaijs.com/

assert 声称
var assert = chai.assert;

assert.typeOf(foo, 'string');
assert.equal(foo, 'bar');
assert.lengthOf(foo, 3)
assert.property(tea, 'flavors');
assert.lengthOf(tea.flavors, 3);

Expect 期望
var expect = chai.expect;

expect(foo).to.be.a('string');
expect(foo).to.equal('bar');
expect(foo).to.have.lengthOf(3);
expect(tea).to.have.property('flavors').with.lengthOf(3);

Should 应该
chai.should();

foo.should.be.a('string');
foo.should.equal('bar');
foo.should.have.lengthOf(3);
tea.should.have.property('flavors').with.lengthOf(3);

*/

const KryptoBird = artifacts.require("./KryptoBird");

// 检查 chai
require("chai")
.use(require("chai-as-promised"))
.should()

contract('KryptoBird', (accounts) => {
    let contract
    //before 告诉 test 在运行这些之前做的时情
    before( async () => {
        contract = await KryptoBird.deployed()
    })
    // 测试容器 - describe

    describe("deploment", async() =>{
        // test samples with writing it
        it("deploys successfuly", async() =>{
            const address = contract.address;
            assert.notEqual(address,"")
            assert.notEqual(address,null)
            assert.notEqual(address,undefined)
            assert.notEqual(address,0x0)
        })

        // 测试 name 的匹配，使用到 assert.equal 函数
        // 测试 symbol
        it("has a name", async() =>{
            const name = await contract.name()
            assert.equal(name, "KryptoBird")
        })
        it("has a symbol", async() =>{
            const symbol = await contract.symbol()
            assert.equal(symbol, "KBIRDZ")
        })
    })
    describe("minting", async () => {
        it('creates a new token',async () => {
            const result = await contract.mint('https...1')
            const totalSupply = await contract.totalSupply()

            // 成功
            assert.equal(totalSupply, 1)
            const event = result.logs[0].args
            assert.equal(event._from, "0x0000000000000000000000000000000000000000", "from is the contract")
            assert.equal(event._to, accounts[0], 'to is msg.sender')

            // 失败
            await contract.mint('https...1').should.be.rejected;
        })
    })

    describe("indexing", async () => {
        it("lists KryptoBirdz", async () => {
            //mint 3个新 tokens
            await contract.mint('https...2')
            await contract.mint('https...3')
            await contract.mint('https...4')
            const totalSupply = await contract.totalSupply()
        
            // 遍历新增的tokens
            let result = []
            let KryptoBird, i
            for(i = 1; i <= totalSupply; i++) {
                KryptoBird = contract.kryptoBirdz(i - 1)
                result.push(KryptoBird)
            }

            // 声称我们的新数组结果将等于我们的预期结果
            let expected = ['https...1','https...2','https...3','https...4']
            assert.equal(result.join(","), result.join(","))
        })


    })

});