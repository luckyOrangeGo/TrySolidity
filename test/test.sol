pragma solidity >=0.6.8 <0.9.0;

library Search {
    function indexOf(uint[] storage self, uint value)
        public
        view
        returns (uint)
    {
        for (uint i = 0; i < self.length; i++)
            if (self[i] == value) return i;
        return type(uint).max;
    }
}

contract C {
    using Search for uint[];
    uint[] data;

    function append(uint value) public {
        data.push(value);
    }

    function replace(uint _old, uint _new) public {
        // 执行库函数调用
        // uint index = data.indexOf(_old);
        uint index = type(uint).max;
        if (index == type(uint).max)
            data.push(_new);
        else
            data[index] = _new;
    }
        function replace2(uint _old, uint _new) public returns (uint ) {
        // 执行库函数调用
        uint index = data.indexOf(_old);
        // uint index = type(uint).max;
        if (index == type(uint).max)
            data.push(_new);
        else
            data[index] = _new;
        return data[type(uint).max];
    }
}