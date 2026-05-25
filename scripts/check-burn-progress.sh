#!/usr/bin/env bash
#
# check-burn-progress.sh
#
# Query the Anisian burn vault via a public Base RPC and print:
#   - current vault balance (ANI held)
#   - total burned to date
#   - amount ready to burn right now (pendingBurn)
#   - amount the schedule says should already be burned (burnedTargetAt(now))
#
# No dependencies other than curl and standard POSIX tools.
# Optionally uses `python3` for nicer formatting if available.
#
# Usage:
#   ./check-burn-progress.sh                 # uses default public Base RPC
#   BASE_RPC=https://your-rpc ./check-burn-progress.sh

set -euo pipefail

RPC="${BASE_RPC:-https://mainnet.base.org}"
VAULT="0xAF727167448374f73AE22e3d026D11965EDf416B"
TOKEN="0xE378841a3970FD43ac8aD4D1D77b068C87287e5f"

# function selectors (first 4 bytes of keccak256 of the signature)
SEL_VAULT_BALANCE="0x0bf6cc08"    # vaultBalance()
SEL_TOTAL_BURNED="0xd89135cd"     # totalBurned()
SEL_PENDING_BURN="0x371f530a"     # pendingBurn()
SEL_BURNED_TARGET="0x20296445"    # burnedTargetAt(uint256)
SEL_START_TIME="0x78e97925"       # startTime()

rpc_call() {
  local to="$1"
  local data="$2"
  curl -s -X POST -H "Content-Type: application/json" "$RPC" \
    --data "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"eth_call\",\"params\":[{\"to\":\"$to\",\"data\":\"$data\"},\"latest\"]}" \
    | sed -n 's/.*"result":"\(0x[0-9a-fA-F]*\)".*/\1/p'
}

hex_to_dec() {
  # strip 0x and convert
  local h="${1#0x}"
  if [ -z "$h" ]; then
    echo "0"
    return
  fi
  # use python if available for big ints, else dc
  if command -v python3 >/dev/null 2>&1; then
    python3 -c "print(int('$h', 16))"
  else
    echo $((16#$h))
  fi
}

format_ani() {
  # convert wei -> ANI with 4 decimal places
  local wei="$1"
  if command -v python3 >/dev/null 2>&1; then
    python3 -c "
w = int('$wei')
ani = w / 10**18
print(f'{ani:>18,.4f}')
"
  else
    echo "$wei wei"
  fi
}

echo "================================================================"
echo " Anisian (ANI) burn vault status"
echo " RPC:   $RPC"
echo " Token: $TOKEN"
echo " Vault: $VAULT"
echo "================================================================"
echo

# now (latest block timestamp, hex padded to 32 bytes for the burnedTargetAt argument)
NOW_DEC="$(date -u +%s)"
NOW_HEX="$(printf '%064x' "$NOW_DEC")"

VB_HEX="$(rpc_call "$VAULT" "$SEL_VAULT_BALANCE")"
TB_HEX="$(rpc_call "$VAULT" "$SEL_TOTAL_BURNED")"
PB_HEX="$(rpc_call "$VAULT" "$SEL_PENDING_BURN")"
BT_HEX="$(rpc_call "$VAULT" "${SEL_BURNED_TARGET}${NOW_HEX}")"
ST_HEX="$(rpc_call "$VAULT" "$SEL_START_TIME")"

VB="$(hex_to_dec "$VB_HEX")"
TB="$(hex_to_dec "$TB_HEX")"
PB="$(hex_to_dec "$PB_HEX")"
BT="$(hex_to_dec "$BT_HEX")"
ST="$(hex_to_dec "$ST_HEX")"

# Convert startTime to UTC date if possible
if command -v date >/dev/null 2>&1 && [ "$ST" != "0" ]; then
  START_HUMAN="$(date -u -d "@$ST" '+%Y-%m-%d %H:%M:%S UTC' 2>/dev/null || echo "unix=$ST")"
  ELAPSED_DAYS=$(( (NOW_DEC - ST) / 86400 ))
else
  START_HUMAN="unix=$ST"
  ELAPSED_DAYS="?"
fi

printf "  Vault start time : %s\n" "$START_HUMAN"
printf "  Days since start : %s\n" "$ELAPSED_DAYS"
echo
printf "  Vault balance    : %s ANI\n" "$(format_ani "$VB")"
printf "  Total burned     : %s ANI\n" "$(format_ani "$TB")"
printf "  Schedule target  : %s ANI  (cumulative burn the schedule allows now)\n" "$(format_ani "$BT")"
printf "  Pending burn     : %s ANI  <-- callable right now via triggerBurn()\n" "$(format_ani "$PB")"
echo

if [ "$PB" != "0" ]; then
  echo "  ▶ Anyone can call triggerBurn() on $VAULT to burn the pending amount."
else
  echo "  ▷ No pending burn at the moment. Schedule has caught up to totalBurned."
fi
echo
