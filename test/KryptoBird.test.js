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

    // 测试容器 - describe

    describe("deploment", async() =>{
        // test samples with writing it
        it("deploys successfuly", async() =>{
            contract = await KryptoBird.deployed();
            const address = contract.address;
            assert.notEqual(address,"")
            assert.notEqual(address,null)
            assert.notEqual(address,undefined)
            assert.notEqual(address,0x0)
        })
    })
});