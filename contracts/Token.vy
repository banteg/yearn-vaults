# @version 0.3.10
# @title TestToken
# @dev Implementation of ERC-20 token standard.
# @author Takayuki Jimba (@yudetamago)
# https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md

from vyper.interfaces import ERC20

implements: ERC20

event Transfer:
    sender: indexed(address)
    receiver: indexed(address)
    amount: uint256

event Approval:
    owner: indexed(address)
    spender: indexed(address)
    amount: uint256

name: public(String[32])
symbol: public(String[32])
decimals: public(constant(uint256)) = 18
balanceOf: public(HashMap[address, uint256])
allowance: public(HashMap[address, HashMap[address, uint256]])
totalSupply: public(uint256)
MAX_MINT: constant(uint256) = 100 * 10**18


@external
def __init__(name: String[32], symbol: String[32]):
    self.name = name
    self.symbol = symbol


@external
def transfer(receiver: address, amount: uint256) -> bool:
    self.balanceOf[msg.sender] -= amount
    self.balanceOf[receiver] += amount
    log Transfer(msg.sender, receiver, amount)
    return True


@external
def transferFrom(owner: address, receiver: address, amount: uint256) -> bool:
    self.balanceOf[owner] -= amount
    self.balanceOf[receiver] += amount
    self.allowance[owner][msg.sender] -= amount
    log Transfer(owner, receiver, amount)
    return True


@external
def approve(spender: address, amount: uint256) -> bool:
    self.allowance[msg.sender][spender] = amount
    log Approval(msg.sender, spender, amount)
    return True


@external
def mint(receiver: address, amount: uint256) -> bool:
    assert amount <= MAX_MINT
    assert receiver != empty(address)
    self.totalSupply += amount
    self.balanceOf[receiver] += amount
    log Transfer(empty(address), receiver, amount)
    return True


@external
def burn(amount: uint256) -> bool:
    self.totalSupply -= amount
    self.balanceOf[msg.sender] -= amount
    log Transfer(msg.sender, empty(address), amount)
    return True
