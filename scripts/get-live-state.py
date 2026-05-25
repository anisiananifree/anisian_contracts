#!/usr/bin/env python3
"""
get-live-state.py
=================

Print a full on-chain snapshot of the Anisian (ANI) protocol on Base mainnet:
  - block number and timestamp
  - total supply, vault balance, pool reserves
  - non-vault balances (deployer, personal wallet)
  - burn vault progress (totalBurned, pendingBurn)
  - implied ANI price in USDC and pool TVL
  - launch protection state (limitsFinalized)

Use this to regenerate the numbers in STATUS.md or to verify the README's claims.

Requires only Python 3 (stdlib). No web3.py, no extra deps.

Usage:
    python3 scripts/get-live-state.py
    BASE_RPC=https://your-rpc python3 scripts/get-live-state.py
"""
import json
import os
import time
import urllib.request
from datetime import datetime, timezone

RPC = os.environ.get("BASE_RPC", "https://base-rpc.publicnode.com")

TOKEN     = "0xE378841a3970FD43ac8aD4D1D77b068C87287e5f"
VAULT     = "0xAF727167448374f73AE22e3d026D11965EDf416B"
POOL      = "0x2F947691C97244D845B2db2f86489D21c4c919bD"
DEPLOYER  = "0xDc1Dbe909Eb6E9bd054e123747ca77A036F16412"
PERSONAL  = "0x412462Ff8E3A3cB96B0b2255114Bd85cC900AF28"

# Function selectors (first 4 bytes of keccak256 of the signature).
# Verified by computing keccak256(sig)[:8] via pycryptodome and cross-checking
# the returned values against the contract sources in ../contracts/.
SEL = {
    "balanceOf":         "0x70a08231",  # balanceOf(address)
    "totalSupply":       "0x18160ddd",  # totalSupply()
    "totalBurned":       "0xd89135cd",  # totalBurned()
    "pendingBurn":       "0x371f530a",  # pendingBurn()
    "vaultBalance":      "0x0bf6cc08",  # vaultBalance()
    "getReserves":       "0x0902f1ac",  # getReserves()
    "limitsFinalized":   "0xbc023556",  # limitsFinalized()
    "protectionEndsAt":  "0xa929442c",  # protectionEndsAt()
    "liquidityCreatedAt":"0x43185304",  # liquidityCreatedAt()
}


def rpc(method, params):
    payload = {"jsonrpc": "2.0", "id": 1, "method": method, "params": params}
    req = urllib.request.Request(
        RPC, data=json.dumps(payload).encode(),
        headers={"Content-Type": "application/json", "User-Agent": "anisian-status/1.0"},
    )
    return json.loads(urllib.request.urlopen(req, timeout=20).read())


def eth_call(to, sel, arg=None):
    data = sel + (("0" * 24) + arg[2:].lower() if arg else "")
    r = rpc("eth_call", [{"to": to, "data": data}, "latest"])
    return r.get("result", "0x0")


def to_int(hex_):
    return int(hex_, 16) if hex_ else 0


def ani(hex_):
    return to_int(hex_) / 10**18


def block_info():
    bn_hex = rpc("eth_blockNumber", [])["result"]
    time.sleep(0.3)
    blk = rpc("eth_getBlockByNumber", [bn_hex, False])["result"]
    return int(bn_hex, 16), int(blk["timestamp"], 16)


def main():
    bn, ts = block_info()
    when = datetime.fromtimestamp(ts, tz=timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC")

    time.sleep(0.3); b_vault    = ani(eth_call(TOKEN, SEL["balanceOf"], VAULT))
    time.sleep(0.3); b_pool     = ani(eth_call(TOKEN, SEL["balanceOf"], POOL))
    time.sleep(0.3); b_depl     = ani(eth_call(TOKEN, SEL["balanceOf"], DEPLOYER))
    time.sleep(0.3); b_pers     = ani(eth_call(TOKEN, SEL["balanceOf"], PERSONAL))
    time.sleep(0.3); total      = ani(eth_call(TOKEN, SEL["totalSupply"]))
    time.sleep(0.3); burned     = ani(eth_call(VAULT, SEL["totalBurned"]))
    time.sleep(0.3); pending    = ani(eth_call(VAULT, SEL["pendingBurn"]))
    time.sleep(0.3); lf_raw     = eth_call(TOKEN, SEL["limitsFinalized"])
    time.sleep(0.3); lca        = to_int(eth_call(TOKEN, SEL["liquidityCreatedAt"]))
    time.sleep(0.3); pea        = to_int(eth_call(TOKEN, SEL["protectionEndsAt"]))
    time.sleep(0.3)

    raw = eth_call(POOL, SEL["getReserves"])[2:]
    usdc_r = int(raw[0:64], 16) / 10**6      # token0 = USDC (6 dec)
    ani_r  = int(raw[64:128], 16) / 10**18    # token1 = ANI  (18 dec)

    price = (usdc_r / ani_r) if ani_r else 0.0
    mcap = price * total
    tvl  = 2 * usdc_r

    print("=" * 72)
    print(" Anisian (ANI) — on-chain snapshot")
    print(f" RPC:   {RPC}")
    print(f" Block: {bn}   Time: {when}")
    print("=" * 72)
    print()
    print("  Balances")
    print("  --------")
    print(f"    Burn vault          {b_vault:>20,.4f} ANI    ({b_vault/total*100:>6.2f} %)")
    print(f"    Aerodrome pool      {b_pool :>20,.4f} ANI    ({b_pool /total*100:>6.2f} %)")
    print(f"    Deployer wallet     {b_depl :>20,.4f} ANI    ({b_depl /total*100:>6.2f} %)")
    print(f"    Personal wallet     {b_pers :>20,.4f} ANI    ({b_pers /total*100:>6.2f} %)")
    print(f"    {'─'*70}")
    print(f"    Total supply        {total  :>20,.4f} ANI    (was 100,000,000 at mint)")
    print(f"    Already burned      {(100_000_000 - total):>20,.4f} ANI")
    print()
    print("  Burn vault")
    print("  ----------")
    print(f"    Total burned        {burned :>20,.4f} ANI")
    print(f"    Pending burn        {pending:>20,.4f} ANI    ← anyone can call triggerBurn() to execute")
    print()
    print("  Pool")
    print("  ----")
    print(f"    USDC reserve        {usdc_r :>20,.4f} USDC")
    print(f"    ANI  reserve        {ani_r  :>20,.4f} ANI")
    print(f"    Implied ANI price   ${price:.12f} USDC per ANI")
    print(f"    Pool TVL            ${tvl:>20,.2f} USD")
    print(f"    Implied market cap  ${mcap:>20,.2f} USD")
    print()
    print("  Launch protection")
    print("  -----------------")
    lca_h = datetime.fromtimestamp(lca, tz=timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC") if lca else "n/a"
    pea_h = datetime.fromtimestamp(pea, tz=timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC") if pea else "n/a"
    print(f"    liquidityCreatedAt  {lca}    ({lca_h})")
    print(f"    protectionEndsAt    {pea}    ({pea_h})")
    print(f"    limitsFinalized()   {bool(to_int(lf_raw))}    (when True, 90-day buy limits are permanently off)")
    print()
    print("  Sanity check")
    print("  ------------")
    sum_all = b_vault + b_pool + b_depl + b_pers
    print(f"    sum(known holders)  {sum_all:>20,.4f} ANI")
    print(f"    totalSupply         {total  :>20,.4f} ANI")
    print(f"    matches?            {abs(sum_all - total) < 1:>20}")
    print()


if __name__ == "__main__":
    main()
